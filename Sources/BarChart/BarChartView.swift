//
//  BarChartView.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/11.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit
import SnapKit

class BarChartView: LiteChartContentView {
    private let configure: BarChartViewConfigure
    
    private var axisView: AxisView?
    private var yUnitLabel: DisplayLabel?
    private var xUnitLabel: DisplayLabel?
    private var coupleTitleView: [DisplayLabel] = []
    private var valueView: [DisplayLabel] = []
    private var barViewCollection: BarViewCoupleCollection?
    
    private var contentLayoutGuide: UILayoutGuide?
    
    init(configure: BarChartViewConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
        insertContentLayoutGuide()
        insertUnitLabel()
        insertAxisView()
        insertBarViewCollection()
        insertValueTitleView()
        insertCoupleTitleView()
        
        updateAxisViewStaticConstraints()
        updateUnitLabelStaticConstraints()
        updateBarViewCoupleCollectionStaticContraints()
        updateAreaLayoutGuideStaticConstraints()
    }
    
    required init?(coder: NSCoder) {
        self.configure = BarChartViewConfigure.emptyConfigure
        super.init(coder: coder)
        insertContentLayoutGuide()
        insertUnitLabel()
        insertAxisView()
        insertBarViewCollection()
        insertValueTitleView()
        insertCoupleTitleView()
        
        updateAxisViewStaticConstraints()
        updateUnitLabelStaticConstraints()
        updateBarViewCoupleCollectionStaticContraints()
        updateAreaLayoutGuideStaticConstraints()
    }
    
    override func layoutSubviews() {
        stopAnimation()
        super.layoutSubviews()
        updateAxisViewDynamicConstraints()
        updateUnitLabelDynamicConstraints()
        updateValueViewDynamicConstraints()
        updateCoupleTitleViewDynamicConstraints()
    }
    
    override var areaLayoutGuide: UILayoutGuide {
        if let layout = self.contentLayoutGuide {
            return layout
        } else {
            return super.areaLayoutGuide
        }
    }
    
    private func insertContentLayoutGuide() {
        if let layout = self.contentLayoutGuide {
            self.removeLayoutGuide(layout)
            self.contentLayoutGuide = nil
        }
        let layout = UILayoutGuide()
        self.contentLayoutGuide = layout
        self.addLayoutGuide(layout)
    }
    
    private func insertUnitLabel() {
        if let xUnitLabel = self.xUnitLabel {
            xUnitLabel.removeFromSuperview()
            self.xUnitLabel = nil
        }
        
        if let yUnitLabel = self.yUnitLabel {
            yUnitLabel.removeFromSuperview()
            self.yUnitLabel = nil
        }
        
        var unitLabel: DisplayLabel
        if self.configure.isShowValueUnitString {
            unitLabel = DisplayLabel(configure: self.configure.valueUnitStringConfigure)
            self.addSubview(unitLabel)
            switch self.configure.direction {
            case .leftToRight:
                self.xUnitLabel = unitLabel
            case .bottomToTop:
                self.yUnitLabel = unitLabel
            }
        }
        
        if self.configure.isShowCoupleUnitString {
            unitLabel = DisplayLabel(configure: self.configure.coupleUnitStringConfigure)
            self.addSubview(unitLabel)
            switch self.configure.direction {
            case .leftToRight:
                self.yUnitLabel = unitLabel
            case .bottomToTop:
                self.xUnitLabel = unitLabel
            }
        }
        
    }
    
    private func insertCoupleTitleView() {
        for titleView in self.coupleTitleView {
            titleView.removeFromSuperview()
        }
        self.coupleTitleView = []
        for coupleTitleConfigure in self.configure.coupleTitleConfigure {
            let titleView = DisplayLabel(configure: coupleTitleConfigure)
            self.addSubview(titleView)
            self.coupleTitleView.append(titleView)
        }
    }
    
    private func insertValueTitleView() {
        for valueView in self.valueView {
            valueView.removeFromSuperview()
        }
        self.valueView = []
        for valueTitleConfigure in self.configure.valueTitleConfigure {
            let valueView = DisplayLabel(configure: valueTitleConfigure)
            self.addSubview(valueView)
            self.valueView.append(valueView)
        }
    }
    
    private func insertAxisView() {
        if let axisView = self.axisView {
            axisView.removeFromSuperview()
            self.axisView = nil
        }
        let axisView = AxisView(configure: self.configure.axisConfigure)
        self.addSubview(axisView)
        self.axisView = axisView
    }
    
    private func insertBarViewCollection() {
        if let barView = self.barViewCollection {
            barView.removeFromSuperview()
            self.barViewCollection = nil
        }
        guard let axis = self.axisView else {
            return
        }
        
        let barViews = BarViewCoupleCollection(configure: self.configure.barViewCoupleCollectionConfigure)
        axis.addSubview(barViews)
        self.barViewCollection = barViews
    }
    
    private var leftUnitViewWidth: CGFloat {
        let leftSpace = self.bounds.width / 15
        return leftSpace
    }
    
    private var leftViewWidth: CGFloat {
        let leftSpace = self.bounds.width / 10
        return leftSpace
    }
    
    private var bottomUnitViewHeight: CGFloat {
        let bottomSpace = self.bounds.height / 15
        return bottomSpace
    }
    
    private var bottomViewHeight: CGFloat {
        let bottomSpace = self.bounds.height / 10
        return bottomSpace
    }
    
    private var labelViewHeightSpace: CGFloat {
        let space = bottomViewHeight / 6
        return space
    }
    
    private var labelViewWidthSpace: CGFloat {
        let space = leftViewWidth / 6
        return space
    }
    
    private var leftSpace: CGFloat {
        var space: CGFloat = 0
        if self.yUnitLabel != nil {
            space += self.labelViewWidthSpace + leftUnitViewWidth
        }
        if !self.coupleTitleView.isEmpty && self.configure.direction == .leftToRight {
            space += self.labelViewWidthSpace + self.leftViewWidth
            return space
        }
        if !self.valueView.isEmpty && self.configure.direction == .bottomToTop {
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
        if !self.coupleTitleView.isEmpty && self.configure.direction == .bottomToTop {
            space += self.labelViewHeightSpace + self.bottomViewHeight
            return space
        }
        if !self.valueView.isEmpty && self.configure.direction == .leftToRight {
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
            unit.snp.remakeConstraints{
                make in
                make.leading.equalToSuperview()
                make.width.equalTo(self.leftUnitViewWidth)
                make.top.equalToSuperview()
                make.bottom.equalTo(axis.snp.bottom)
            }
        }
        
        if let xUnit = self.xUnitLabel {
            xUnit.snp.remakeConstraints{
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
        axis.snp.remakeConstraints{
            make in
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.leading.equalToSuperview().priority(750)
            make.bottom.equalToSuperview().priority(750)
        }
    }
    
    private func updateAxisViewDynamicConstraints() {
        guard let axis = self.axisView else {
            return
        }
        axis.snp.updateConstraints{
            make in
            make.leading.equalToSuperview().offset(self.leftSpace).priority(750)
            make.bottom.equalToSuperview().offset(0 - self.bottomSpace).priority(750)
        }
    }
    
    private func updateBarViewCoupleCollectionStaticContraints() {
        guard let collection = self.barViewCollection else {
            return
        }
        collection.snp.remakeConstraints{
            make in
            make.bottom.top.trailing.leading.equalToSuperview()
        }
    }
    
    private func updateAreaLayoutGuideStaticConstraints() {
        guard let axis = self.axisView else {
            return
        }
        areaLayoutGuide.snp.remakeConstraints{
            make in
            make.bottom.top.leading.trailing.equalTo(axis)
        }
    }
    
    private func updateValueViewDynamicConstraints() {
        guard let axis = self.axisView else {
            return
        }
        switch self.configure.direction {
        case .bottomToTop:
            guard self.configure.yDividingPoints.count == self.configure.valueTitleConfigure.count,  self.configure.valueTitleConfigure.count == self.valueView.count else {
                fatalError("框架内部数据处理错误，不给予拯救")
            }
            for index in 0 ..< self.configure.valueTitleConfigure.count {
                let yPoint = self.configure.yDividingPoints[index]
                let pointY = axis.bounds.height * (1 - yPoint)
                let endPoint = CGPoint(x: self.bounds.origin.x + self.leftSpace, y: self.bounds.origin.y + pointY)
                let center = CGPoint(x: endPoint.x - self.labelViewWidthSpace - self.leftViewWidth / 2, y: endPoint.y)
                let labelHeight = axis.bounds.height / CGFloat(self.configure.valueTitleConfigure.count + 1)
                let labelView = self.valueView[index]
                labelView.snp.updateConstraints{
                    make in
                    make.center.equalTo(center)
                    make.width.equalTo(self.leftViewWidth)
                    make.height.equalTo(labelHeight)
                }
            }
        case .leftToRight:
            guard self.configure.xDividingPoints.count == self.configure.valueTitleConfigure.count, self.configure.valueTitleConfigure.count == self.valueView.count else {
                fatalError("框架内部数据处理错误，不给予拯救")
            }
            for index in 0 ..< self.configure.valueTitleConfigure.count {
                let xPoint = self.configure.xDividingPoints[index]
                let pointX = axis.bounds.width * xPoint
                let endPoint = CGPoint(x: self.bounds.origin.x + self.leftSpace + pointX, y: self.bounds.origin.y + axis.bounds.height)
                let center = CGPoint(x: endPoint.x, y: endPoint.y + self.labelViewHeightSpace + self.bottomViewHeight / 2)
                let labelWidth = axis.bounds.width / CGFloat(self.configure.valueTitleConfigure.count + 1)
                let labelView = self.valueView[index]
                labelView.snp.updateConstraints{
                    make in
                    make.center.equalTo(center)
                    make.height.equalTo(self.bottomViewHeight)
                    make.width.equalTo(labelWidth)
                }
            }
        }
    }
    
    private func updateCoupleTitleViewDynamicConstraints() {
        guard let axis = self.axisView else {
            return
        }
        guard self.configure.barViewCoupleNumber > 0 else {
            return
        }
        
        switch self.configure.direction {
        case .bottomToTop:
            guard self.configure.coupleTitleConfigure.count == self.configure.barViewCoupleNumber else {
                fatalError("框架内部数据处理错误，不给予拯救")
            }
            let labelWidth = axis.bounds.width / CGFloat(self.configure.barViewCoupleNumber)
            let labelSpace = labelWidth / 10
            var frontView: DisplayLabel?
            for labelView in self.coupleTitleView {
                labelView.snp.updateConstraints{
                    make in
                    if let front = frontView {
                        make.leading.equalTo(front.snp.trailing).offset(labelSpace).priority(750)
                    } else {
                        make.leading.equalTo(axis.snp.leading).offset(labelSpace / 2).priority(750)
                    }
                    make.top.equalTo(axis.snp.bottom).offset(self.labelViewHeightSpace).priority(750)
                    make.height.equalTo(self.bottomViewHeight)
                    make.width.equalTo(labelWidth - labelSpace)
                }
                frontView = labelView
            }
        case .leftToRight:
            guard self.configure.coupleTitleConfigure.count == self.configure.barViewCoupleNumber else {
                fatalError("框架内部数据处理错误，不给予拯救")
            }
            let labelHeight = axis.bounds.height / CGFloat(self.configure.barViewCoupleNumber)
            let labelSpace = labelHeight / 10
            var frontView: DisplayLabel?
            for labelView in self.coupleTitleView {
                labelView.snp.updateConstraints{
                    make in
                    if let front = frontView {
                        make.bottom.equalTo(front.snp.top).offset(0 - labelSpace).priority(750)
                    } else {
                        make.bottom.equalTo(axis.snp.bottom).offset(0 - labelSpace / 2).priority(750)
                    }
                    make.trailing.equalTo(axis.snp.leading).offset(0 - self.labelViewWidthSpace).priority(750)
                    make.height.equalTo(labelHeight - labelSpace)
                    make.width.equalTo(self.leftViewWidth)
                }
                frontView = labelView
            }
        }
    }
    
    override func startAnimation(animation: LiteChartAnimationInterface) {
        self.barViewCollection?.startAnimation(animation: animation)
    }
    
    override func stopAnimation() {
        self.barViewCollection?.stopAnimation()
    }
    
    override func pauseAnimation() {
        self.barViewCollection?.pauseAnimation()
    }
    
    override func continueAnimation() {
        self.barViewCollection?.continueAnimation()
    }
    
    override var animationStatus: LiteChartAnimationStatus {
        guard let barViewCollection = self.barViewCollection else {
            return .ready
        }
        return barViewCollection.animationStatus
    }
}
