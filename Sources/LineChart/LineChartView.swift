//
//  LineChartView.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/17.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit

class LineChartView: LiteChartContentView {
    private let configure: LineChartViewConfigure
    
    private var axisView: AxisView?
    private var yUnitLabel: DisplayLabel?
    private var xUnitLabel: DisplayLabel?
    private var coupleTitleView: [DisplayLabel] = []
    private var valueView: [DisplayLabel] = []
    private var lineViews: LineViews?
    
    init(configure: LineChartViewConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
        insertUnitLabel()
        insertAxisView()
        insertValueTitleView()
        insertCoupleTitleView()
        insertLineViews()
        
        updateAxisViewStaticConstraints()
        updateUnitLabelStaticConstraints()
        updateLineViewsStaticContraints()
    }
    
    required init?(coder: NSCoder) {
        self.configure = LineChartViewConfigure.emptyConfigure
        super.init(coder: coder)
        insertUnitLabel()
        insertAxisView()
        insertValueTitleView()
        insertCoupleTitleView()
        insertLineViews()
        
        updateAxisViewStaticConstraints()
        updateUnitLabelStaticConstraints()
        updateLineViewsStaticContraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateAxisViewDynamicConstraints()
        updateUnitLabelDynamicConstraints()
        updateValueViewDynamicConstraints()
        updateCoupleTitleViewDynamicConstraints()
    }
    
    private func insertUnitLabel() {
        var unitLabel: DisplayLabel
        
        if self.configure.isShowValueUnitString  {
            unitLabel = DisplayLabel(configure: self.configure.valueUnitStringConfigure)
            self.yUnitLabel = unitLabel
            self.addSubview(unitLabel)
        }
        
        
        if self.configure.isShowCoupleUnitString {
            unitLabel = DisplayLabel(configure: self.configure.coupleUnitStringConfigure)
            self.xUnitLabel = unitLabel
            self.addSubview(unitLabel)
        }
        
    }
    
    private func insertCoupleTitleView() {
        for configure in self.configure.coupleTitleConfigure {
            let titleView = DisplayLabel(configure: configure)
            self.addSubview(titleView)
            self.coupleTitleView.append(titleView)
        }
    }
    
    private func insertValueTitleView() {
        for configure in self.configure.valueTitleConfigure {
            let valueView = DisplayLabel(configure: configure)
            self.addSubview(valueView)
            self.valueView.append(valueView)
        }
    }
    
    private func insertAxisView() {
        let axisView = AxisView(configure: self.configure.axisConfigure)
        self.addSubview(axisView)
        self.axisView = axisView
    }
    
    private func insertLineViews() {
        guard let axis = self.axisView else {
            return
        }
        let lineViews = LineViews(configure: self.configure.lineViewsConfigure)
        axis.addSubview(lineViews)
        self.lineViews = lineViews
    }
    
    private var leftUnitViewWidth: CGFloat {
        let leftSpace = self.bounds.width / 10
        return min(leftSpace, 20)
    }
    
    private var leftViewWidth: CGFloat {
        let leftSpace = self.bounds.width / 10
        return min(leftSpace, 20)
    }
    
    private var bottomUnitViewHeight: CGFloat {
        let bottomSpace = self.bounds.height / 10
        return min(bottomSpace, 20)
    }
    
    private var bottomViewHeight: CGFloat {
        let bottomSpace = self.bounds.height / 10
        return min(bottomSpace, 20)
    }
    
    private var labelViewHeightSpace: CGFloat {
        let space = self.bounds.height / 10
        return min(space, 4)
    }
    
    private var labelViewWidthSpace: CGFloat {
        let space = self.bounds.width / 10
        return min(space, 4)
    }
    
    private var leftSpace: CGFloat {
        var space: CGFloat = 0
        if self.yUnitLabel != nil {
            space += self.labelViewWidthSpace + self.leftUnitViewWidth
        }
        if !self.valueView.isEmpty {
            space += self.labelViewWidthSpace + self.leftViewWidth
            return space
        }
        return space
    }
    
    private var bottomSpace: CGFloat {
        var space: CGFloat = 0
        if self.xUnitLabel != nil {
            space += self.labelViewHeightSpace + self.bottomUnitViewHeight
        }
        if !self.coupleTitleView.isEmpty {
            space += self.labelViewHeightSpace + self.bottomViewHeight
            return space
        }
        return space
    }
    
    private func updateUnitLabelStaticConstraints() {
        guard let axis = self.axisView else {
            return
        }
        
        if let unit = self.yUnitLabel {
            unit.snp.updateConstraints{
                make in
                make.leading.equalToSuperview()
                make.width.equalTo(self.leftUnitViewWidth)
                make.top.equalToSuperview()
                make.bottom.equalTo(axis.snp.bottom)
            }
        }
        
        if let xUnit = self.xUnitLabel {
            xUnit.snp.updateConstraints{
                make in
                make.leading.equalTo(axis.snp.leading)
                make.trailing.equalToSuperview()
                make.bottom.equalToSuperview()
                make.height.equalTo(self.bottomUnitViewHeight)
            }
        }
        
    }
    
    private func updateUnitLabelDynamicConstraints() {
        
        if let unit = self.yUnitLabel {
            unit.snp.updateConstraints{
                make in
                make.width.equalTo(self.leftUnitViewWidth)
            }
        }
        
        if let xUnit = self.xUnitLabel {
            xUnit.snp.updateConstraints{
                make in
                make.height.equalTo(self.bottomUnitViewHeight)
            }
        }
    }
    
    private func updateAxisViewStaticConstraints() {
        guard let axis = self.axisView else {
            return
        }
        axis.snp.updateConstraints{
            make in
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(self.leftSpace)
            make.bottom.equalToSuperview().offset(0 - self.bottomSpace)
        }
    }
    
    private func updateAxisViewDynamicConstraints() {
        guard let axis = self.axisView else {
            return
        }
        axis.snp.updateConstraints{
            make in
            make.leading.equalToSuperview().offset(self.leftSpace)
            make.bottom.equalToSuperview().offset(0 - self.bottomSpace)
        }
    }
    
    private func updateLineViewsStaticContraints() {
        guard let lineViews = self.lineViews else {
            return
        }
        lineViews.snp.updateConstraints{
            make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
    private func updateValueViewDynamicConstraints() {
        guard let axis = self.axisView else {
            return
        }
        guard self.configure.yDividingPoints.count == self.configure.valueTitleConfigure.count,  self.configure.valueTitleConfigure.count == self.valueView.count else {
            fatalError("框架内部数据处理错误，不给予拯救")
        }
        for index in 0 ..< self.configure.valueTitleConfigure.count {
            let yPoint = self.configure.yDividingPoints[index]
            let pointY = axis.bounds.height * (1 - yPoint)
            let endPoint = CGPoint(x: self.bounds.origin.x + self.leftSpace, y: self.bounds.origin.y + pointY)
            let center = CGPoint(x: endPoint.x - self.labelViewWidthSpace - self.leftViewWidth / 2, y: endPoint.y)
            var labelHeight = axis.bounds.height / CGFloat(self.configure.valueTitleConfigure.count + 1)
            labelHeight = min(labelHeight, 20)
            let labelView = self.valueView[index]
            labelView.snp.updateConstraints{
                make in
                make.center.equalTo(center)
                make.width.equalTo(self.leftViewWidth)
                make.height.equalTo(labelHeight)
            }
        }
    }
    
    private func updateCoupleTitleViewDynamicConstraints() {
        guard let axis = self.axisView else {
            return
        }
        
        guard self.configure.coupleTitleConfigure.count == self.configure.xDividingPoints.count, self.configure.coupleTitleConfigure.count == self.coupleTitleView.count else {
            fatalError("框架内部数据处理错误，不给予拯救")
        }
        var labelWidth = axis.bounds.width / CGFloat(self.configure.coupleTitleConfigure.count + 1)
        labelWidth = min(labelWidth, 20)
        
        for index in 0 ..< self.configure.coupleTitleConfigure.count {
            let xPoint = self.configure.xDividingPoints[index]
            let pointX = axis.bounds.width * xPoint
            let endPoint = CGPoint(x: self.bounds.origin.x + self.leftSpace + pointX, y: self.bounds.origin.y + axis.bounds.height)
            let center = CGPoint(x: self.bounds.origin.x + self.leftSpace + pointX, y: endPoint.y + self.labelViewHeightSpace + self.bottomViewHeight / 2)
            let couple = self.coupleTitleView[index]
            couple.snp.updateConstraints{
                make in
                make.center.equalTo(center)
                make.height.equalTo(self.bottomViewHeight)
                make.width.equalTo(labelWidth)
            }
        }
    }
    
}
