//
//  LineChartView.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/17.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit

class LineChartView: UIView {
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
            unitLabel = DisplayLabel(configure: .init(contentString: self.configure.valueUnitString, contentColor: self.configure.textColor, textAlignment: .center, textDirection: .vertical, syncIdentifier: .lineUnitTitleLabel))
            self.yUnitLabel = unitLabel
            self.addSubview(unitLabel)
        }
        
        
        if self.configure.isShowCoupleUnitString {
            unitLabel = DisplayLabel(configure: .init(contentString: self.configure.coupleUnitString, contentColor: self.configure.textColor, syncIdentifier: .lineUnitTitleLabel))
            self.xUnitLabel = unitLabel
            self.addSubview(unitLabel)
        }
        
    }
    
    private func insertCoupleTitleView() {
        for title in self.configure.coupleTitle {
            let titleView = DisplayLabel(configure: .init(contentString: title, contentColor: self.configure.textColor, syncIdentifier: .lineCoupleTitleLabel))
            self.addSubview(titleView)
            self.coupleTitleView.append(titleView)
        }
    }
    
    private func insertValueTitleView() {
        for value in self.configure.valueTitle {
            let valueView = DisplayLabel(configure: .init(contentString: value, contentColor: self.configure.textColor, textAlignment: .right, syncIdentifier: .lineValueTitleLabel))
            self.addSubview(valueView)
            self.valueView.append(valueView)
        }
    }
    
    private func insertAxisView() {
        let borderStlye: [AxisViewBorderStyle]
        switch self.configure.borderStyle {
        case .halfSurrounded:
            borderStlye = [.left, .bottom]
        case .fullySurrounded:
            borderStlye = [.left, .bottom, .right, .top]
        }
        let axisView = AxisView(configure: .init(originPoint: self.configure.axisOriginal, axisColor: self.configure.axisColor, verticalDividingPoints: self.configure.yDividingPoints, horizontalDividingPoints: self.configure.xDividingPoints, borderStyle: borderStlye, borderColor: self.configure.borderColor, isShowXAxis: self.configure.isShowAxis, isShowYAxis: false))
        self.addSubview(axisView)
        self.axisView = axisView
    }
    
    private func insertLineViews() {
        guard let axis = self.axisView else {
            return
        }
        
        let inputDatas = self.configure.inputDatas
        
        guard !inputDatas.isEmpty else {
            return
        }
        
        if inputDatas.count >= 2 {
            let firstDatasCount = inputDatas[0].3.count
            for inputData in inputDatas {
                if inputData.3.count != firstDatasCount {
                    fatalError("框架内部数据处理错误，不给予拯救!")
                }
            }
        }
        
        var configures: [LineViewConfigure] = []
        for inputData in inputDatas {
            let titleStringConfigure = inputData.3.map{
                DisplayLabelConfigure(contentString: $0.0, contentColor: inputData.0, syncIdentifier: .lineTitleLabel)
            }
            let points = inputData.3.map{
                $0.1
            }
            let lineConfigure = LineViewConfigure(points: points, legendConfigure: .init(type: inputData.2, color: inputData.0), lineStyle: inputData.1, lineColor: inputData.0, labelConfigure: titleStringConfigure, isShowLabel: self.configure.isShowLabel)
            configures.append(lineConfigure)
        }
        let lineViews = LineViews(configure: .init(models: configures))
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
        if !self.coupleTitleView.isEmpty {
            space += self.labelViewWidthSpace + self.leftViewWidth
            return space
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
        if !self.valueView.isEmpty {
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
                make.left.equalToSuperview()
                make.width.equalTo(self.leftUnitViewWidth)
                make.top.equalToSuperview()
                make.bottom.equalTo(axis.snp.bottom)
            }
        }
        
        if let xUnit = self.xUnitLabel {
            xUnit.snp.updateConstraints{
                make in
                make.left.equalTo(axis.snp.left)
                make.right.equalToSuperview()
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
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(self.leftSpace)
            make.bottom.equalToSuperview().offset(0 - self.bottomSpace)
        }
    }
    
    private func updateAxisViewDynamicConstraints() {
        guard let axis = self.axisView else {
            return
        }
        axis.snp.updateConstraints{
            make in
            make.left.equalToSuperview().offset(self.leftSpace)
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
        guard self.configure.yDividingPoints.count == self.configure.valueTitle.count,  self.configure.valueTitle.count == self.valueView.count else {
            fatalError("框架内部数据处理错误，不给予拯救")
        }
        for index in 0 ..< self.configure.valueTitle.count {
            let yPoint = self.configure.yDividingPoints[index]
            let pointY = axis.bounds.height * (1 - yPoint.location)
            let endPoint = CGPoint(x: self.bounds.origin.x + self.leftSpace, y: self.bounds.origin.y + pointY)
            let center = CGPoint(x: endPoint.x - self.labelViewWidthSpace - self.leftViewWidth / 2, y: endPoint.y)
            var labelHeight = axis.bounds.height / CGFloat(self.configure.valueTitle.count + 1)
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
        
        guard self.configure.coupleTitle.count == self.configure.xDividingPoints.count, self.configure.coupleTitle.count == self.coupleTitleView.count else {
            fatalError("框架内部数据处理错误，不给予拯救")
        }
        var labelWidth = axis.bounds.width / CGFloat(self.configure.coupleTitle.count + 1)
        labelWidth = min(labelWidth, 20)
        
        for index in 0 ..< self.configure.coupleTitle.count {
            let xPoint = self.configure.xDividingPoints[index]
            let pointX = axis.bounds.width * xPoint.location
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
