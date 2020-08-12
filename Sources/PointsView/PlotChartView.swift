//
//  PlotChartView.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/20.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit
import SnapKit

class PlotChartView: UIView {
    private let configure: PlotChartViewConfigure
    
    private var axisView: AxisView?
    private var yUnitLabel: DisplayLabel?
    private var xUnitLabel: DisplayLabel?
    private var coupleTitleView: [DisplayLabel] = []
    private var valueView: [DisplayLabel] = []
    private var pointViews: PointViews?
    
    init(configure: PlotChartViewConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
        insertUnitLabel()
        insertAxisView()
        insertValueTitleView()
        insertCoupleTitleView()
        insertPointViews()
        
        updateAxisViewStaticConstraints()
        updateUnitLabelStaticConstraints()
        updatePointViewsStaticContraints()
    }
    
    required init?(coder: NSCoder) {
        self.configure = PlotChartViewConfigure.emptyConfigure
        super.init(coder: coder)
        insertUnitLabel()
        insertAxisView()
        insertValueTitleView()
        insertCoupleTitleView()
        insertPointViews()
        
        updateAxisViewStaticConstraints()
        updateUnitLabelStaticConstraints()
        updatePointViewsStaticContraints()
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
        
        if self.configure.isShowValueUnitString {
            unitLabel = DisplayLabel(configure: .init(contentString: self.configure.valueUnitString, contentColor: self.configure.textColor, textAlignment: .center, textDirection: .vertical))
            self.yUnitLabel = unitLabel
            self.addSubview(unitLabel)
        }
        
        
        if self.configure.isShowCoupleUnitString {
            unitLabel = DisplayLabel(configure: .init(contentString: self.configure.coupleUnitString, contentColor: self.configure.textColor))
            self.xUnitLabel = unitLabel
            self.addSubview(unitLabel)
        }
        
    }
    
    private func insertCoupleTitleView() {
        for title in self.configure.coupleTitle {
            let titleView = DisplayLabel(configure: .init(contentString: title, contentColor: self.configure.textColor))
            self.addSubview(titleView)
            self.coupleTitleView.append(titleView)
        }
    }
    
    private func insertValueTitleView() {
        for value in self.configure.valueTitle {
            let valueView = DisplayLabel(configure: .init(contentString: value, contentColor: self.configure.textColor, textAlignment: .right))
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
        let axisView = AxisView(configure: .init(originPoint: self.configure.axisOriginal, axisColor: self.configure.axisColor, verticalDividingPoints: self.configure.yDividingPoints, horizontalDividingPoints: self.configure.xDividingPoints, borderStyle: borderStlye, borderColor: self.configure.borderColor, isShowXAxis: true, isShowYAxis: true))
        self.addSubview(axisView)
        self.axisView = axisView
    }
    
    private func insertPointViews() {
        guard let axis = self.axisView else {
            return
        }
        
        let inputDatas = self.configure.inputDatas
        
        guard !inputDatas.isEmpty else {
            return
        }
        
        var configures: [PointsViewConfigure] = []
        for inputData in inputDatas {
            var pointConfigure: [PointConfigure] = []
            for point in inputData.2 {
                let configure = PointConfigure(location: point.2, legendConfigure: .init(type: inputData.1, color: inputData.0), size: point.0, opacity: point.1)
                pointConfigure.append(configure)
            }
            let con = PointsViewConfigure(points: pointConfigure)
            configures.append(con)
        }
        let pointViews = PointViews(configure: .init(models: configures))
        axis.addSubview(pointViews)
        self.pointViews = pointViews
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
    
    private var labelViewSpace: CGFloat {
        let space = self.bounds.height / 10
        return min(space, 4)
    }
    
    private var leftSpace: CGFloat {
        if self.yUnitLabel != nil {
            return self.leftViewWidth + self.labelViewSpace * 2 + self.leftUnitViewWidth
        }
        return self.leftViewWidth + self.labelViewSpace
    }
    
    private var bottomSpace: CGFloat {
        if self.xUnitLabel != nil {
            return self.bottomViewHeight + self.labelViewSpace * 2 + self.bottomUnitViewHeight
        }
        return self.bottomViewHeight + self.labelViewSpace
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
    
    private func updatePointViewsStaticContraints() {
        guard let pointViews = self.pointViews else {
            return
        }
        pointViews.snp.updateConstraints{
            make in
            make.trailing.top.bottom.leading.equalToSuperview()
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
            let center = CGPoint(x: endPoint.x - self.labelViewSpace - self.leftViewWidth / 2, y: endPoint.y)
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
            let center = CGPoint(x: self.bounds.origin.x + self.leftSpace + pointX, y: endPoint.y + self.labelViewSpace + self.bottomViewHeight / 2)
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
