//
//  BarChartView.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/11.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit
import SnapKit

class BarChartView: UIView {
    let configure: BarChartViewConfigure
    
    var axisView: AxisView?
    var yUnitLabel: DisplayLabel?
    var xUnitLabel: DisplayLabel?
    var coupleTitleView: [DisplayLabel] = []
    var valueView: [DisplayLabel] = []
    var barView: [BarViews] = []
    
    init(configure: BarChartViewConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
        insertUnitLabel()
        insertAxisView()
        insertBarViews()
        insertValueTitleView()
        insertCoupleTitleView()
        
        updateAxisViewStaticConstraints()
        updateUnitLabelStaticConstraints()
        updateBarViewsStaticContraints()
    }
    
    required init?(coder: NSCoder) {
        self.configure = BarChartViewConfigure.emptyConfigure
        super.init(coder: coder)
        insertUnitLabel()
        insertAxisView()
        insertBarViews()
        insertValueTitleView()
        insertCoupleTitleView()
        
        updateAxisViewStaticConstraints()
        updateUnitLabelStaticConstraints()
        updateBarViewsStaticContraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateAxisViewDynamicConstraints()
        updateUnitLabelDynamicConstraints()
        updateBarViewsDynamicContraints()
        updateValueViewDynamicConstraints()
        updateCoupleTitleViewDynamicConstraints()
    }
    
    private func insertUnitLabel() {
        var unitLabel: DisplayLabel
        
        if self.configure.isShowValueUnitString {
            switch self.configure.direction {
            case .leftToRight:
                unitLabel = DisplayLabel(configure: .init(contentString: self.configure.valueUnitString, contentColor: self.configure.textColor, syncIdentifier: .barUnitTitleLabel))
                self.xUnitLabel = unitLabel
            case .bottomToTop:
                unitLabel = DisplayLabel(configure: .init(contentString: self.configure.valueUnitString, contentColor: self.configure.textColor, textAlignment: .center, textDirection: .vertical, syncIdentifier: .barUnitTitleLabel))
                self.yUnitLabel = unitLabel
            }
            self.addSubview(unitLabel)
        }
        
        if self.configure.isShowCoupleUnitString {
            switch self.configure.direction {
            case .leftToRight:
                unitLabel = DisplayLabel(configure: .init(contentString: self.configure.coupleUnitString, contentColor: self.configure.textColor, textAlignment: .center, textDirection: .vertical, syncIdentifier: .barUnitTitleLabel))
                self.yUnitLabel = unitLabel
            case .bottomToTop:
                unitLabel = DisplayLabel(configure: .init(contentString: self.configure.coupleUnitString, contentColor: self.configure.textColor, syncIdentifier: .barUnitTitleLabel))
                self.xUnitLabel = unitLabel
            }
            self.addSubview(unitLabel)
        }
        
        
    }
    
    private func insertCoupleTitleView() {
        for title in self.configure.coupleTitle {
            let titleView: DisplayLabel
            switch self.configure.direction {
            case .bottomToTop:
                titleView = DisplayLabel(configure: .init(contentString: title, contentColor: self.configure.textColor, syncIdentifier: .barCoupleTitleLabel))
            case .leftToRight:
                titleView = DisplayLabel(configure: .init(contentString: title, contentColor: self.configure.textColor, textAlignment: .right, syncIdentifier: .barCoupleTitleLabel))
            }
            self.addSubview(titleView)
            self.coupleTitleView.append(titleView)
        }
    }
    
    private func insertValueTitleView() {
        for value in self.configure.valueTitle {
            let valueView: DisplayLabel
            switch self.configure.direction {
            case .bottomToTop:
                valueView = DisplayLabel(configure: .init(contentString: value, contentColor: self.configure.textColor, textAlignment: .right, syncIdentifier: .barValueTitleLabel))
            case .leftToRight:
                valueView = DisplayLabel(configure: .init(contentString: value, contentColor: self.configure.textColor, syncIdentifier: .barValueTitleLabel))
            }
            self.addSubview(valueView)
            self.valueView.append(valueView)
        }
    }
    
    private func insertAxisView() {
        let original = CGPoint(x: 0, y: 0)
        let borderStlye: [AxisViewBorderStyle]
        switch self.configure.borderStyle {
        case .halfSurrounded:
            borderStlye = [.left, .bottom]
        case .fullySurrounded:
            borderStlye = [.left, .bottom, .right, .top]
        }
        let axisView = AxisView(configure: .init(originPoint: original, axisColor: self.configure.borderColor, verticalDividingPoints: self.configure.yDividingPoints, horizontalDividingPoints: self.configure.xDividingPoints, borderStyle: borderStlye, borderColor: self.configure.borderColor, isShowXAxis: false, isShowYAxis: false))
        self.addSubview(axisView)
        self.axisView = axisView
    }
    
    private func insertBarViews() {
        guard let axis = self.axisView else {
            return
        }
        
        let inputDatas = self.configure.inputDatas
        
        guard !inputDatas.isEmpty else {
            return
        }
        
        if inputDatas.count >= 2 {
            let firstDatasCount = inputDatas[0].1.count
            for inputData in inputDatas {
                if inputData.1.count != firstDatasCount {
                    fatalError("框架内部数据处理错误，不给予拯救!")
                }
            }
        }
        let coupleCount = inputDatas[0].1.count
        var coupleBarsInputDatas: [[(LiteChartDarkLightColor, CGFloat, String)]] = Array(repeating: [], count: coupleCount)
        
        for inputData in inputDatas {
            for index in 0 ..< coupleCount {
                var coupleBars = coupleBarsInputDatas[index]
                coupleBars.append((inputData.0, inputData.1[index].1, inputData.1[index].0))
                coupleBarsInputDatas[index] = coupleBars
            }
        }
        
        let textAlignment: NSTextAlignment
        switch self.configure.direction {
        case .bottomToTop:
            textAlignment = .center
        case .leftToRight:
            textAlignment = .left
        }
        
        for coupleBars in coupleBarsInputDatas {
            var barViewsConfigure: [BarViewConfigure] = []
            for input in coupleBars {
                if self.configure.isShowLabel {
                    let barViewConfigure = BarViewConfigure(length: input.1, barColor: input.0, isShowLabel: true, label: DisplayLabelConfigure(contentString: input.2, contentColor: self.configure.textColor, textAlignment: textAlignment, syncIdentifier: .barTitleLabel), direction: self.configure.direction)
                    barViewsConfigure.append(barViewConfigure)
                } else {
                    let barViewConfigure = BarViewConfigure(length: input.1, barColor: input.0, isShowLabel: false, direction: self.configure.direction)
                    barViewsConfigure.append(barViewConfigure)
                }
            }
            let barViews = BarViews(configure: .init(models: barViewsConfigure, direction: self.configure.direction))
            axis.addSubview(barViews)
            self.barView.append(barViews)
        }
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
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
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
    
    private func updateBarViewsStaticContraints() {
        let itemCount = self.barView.count
        guard let axis = self.axisView, itemCount > 0 else {
            return
        }
        
        var frontView: BarViews?
        
        switch self.configure.direction {
        case .bottomToTop:
            for barView in self.barView {
                guard let front = frontView else {
                    barView.snp.updateConstraints{
                        make in
                        make.left.equalTo(axis.snp.left)
                        make.width.equalTo(0)
                        make.bottom.equalTo(axis.snp.bottom)
                        make.top.equalTo(axis.snp.top)
                    }
                    frontView = barView
                    continue
                }
                barView.snp.updateConstraints{
                    make in
                    make.left.equalTo(front.snp.right)
                    make.width.equalTo(front.snp.width)
                    make.bottom.equalTo(axis.snp.bottom)
                    make.top.equalTo(axis.snp.top)
                }
                frontView = barView
            }
        case .leftToRight:
            for barView in self.barView {
                guard let front = frontView else {
                    barView.snp.updateConstraints{
                        make in
                        make.left.equalTo(axis.snp.left)
                        make.height.equalTo(0)
                        make.bottom.equalTo(axis.snp.bottom)
                        make.right.equalTo(axis.snp.right)
                    }
                    frontView = barView
                    continue
                }
                barView.snp.updateConstraints{
                    make in
                    make.left.equalTo(axis.snp.left)
                    make.height.equalTo(front.snp.height)
                    make.bottom.equalTo(front.snp.top)
                    make.right.equalTo(axis.snp.right)
                }
                frontView = barView
            }
        }
    }
    
    private func updateBarViewsDynamicContraints() {
        let itemCount = self.barView.count
        guard let axis = self.axisView, itemCount > 0 else {
            return
        }
        guard let first = self.barView.first else {
            return
        }
        switch self.configure.direction {
        case .bottomToTop:
            let itemWidth = axis.bounds.width / CGFloat(itemCount)
            first.snp.updateConstraints{
                make in
                make.width.equalTo(itemWidth)
            }
        case .leftToRight:
            let itemHeight = axis.bounds.height / CGFloat(itemCount)
            first.snp.updateConstraints{
                make in
                make.height.equalTo(itemHeight)
            }
        }
    }
    
    private func updateValueViewDynamicConstraints() {
        guard let axis = self.axisView else {
            return
        }
        switch self.configure.direction {
        case .bottomToTop:
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
        case .leftToRight:
            guard self.configure.xDividingPoints.count == self.configure.valueTitle.count, self.configure.valueTitle.count == self.valueView.count else {
                fatalError("框架内部数据处理错误，不给予拯救")
            }
            for index in 0 ..< self.configure.valueTitle.count {
                let xPoint = self.configure.xDividingPoints[index].location
                let pointX = axis.bounds.width * xPoint
                let endPoint = CGPoint(x: self.bounds.origin.x + self.leftSpace + pointX, y: self.bounds.origin.y + axis.bounds.height)
                let center = CGPoint(x: endPoint.x, y: endPoint.y + self.labelViewHeightSpace + self.bottomViewHeight / 2)
                var labelWidth = axis.bounds.width / CGFloat(self.configure.valueTitle.count + 1)
                labelWidth = min(labelWidth, 20)
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
        
        switch self.configure.direction {
        case .bottomToTop:
            guard self.configure.coupleTitle.count == self.barView.count else {
                fatalError("框架内部数据处理错误，不给予拯救")
            }
            let labelWidth = axis.bounds.width / CGFloat(self.configure.coupleTitle.count)
            var labelSpace = labelWidth / 10
            labelSpace = min(labelSpace, 4)
            var frontView: DisplayLabel?
            for labelView in self.coupleTitleView {
                guard let front = frontView else {
                    labelView.snp.updateConstraints{
                        make in
                        make.left.equalTo(axis.snp.left).offset(labelSpace / 2)
                        make.top.equalTo(axis.snp.bottom).offset(self.labelViewHeightSpace)
                        make.height.equalTo(self.bottomViewHeight)
                        make.width.equalTo(labelWidth - labelSpace)
                    }
                    frontView = labelView
                    continue
                }
                labelView.snp.updateConstraints{
                    make in
                    make.left.equalTo(front.snp.right).offset(labelSpace)
                    make.top.equalTo(axis.snp.bottom).offset(self.labelViewHeightSpace)
                    make.height.equalTo(self.bottomViewHeight)
                    make.width.equalTo(labelWidth - labelSpace)
                }
                frontView = labelView
            }
        case .leftToRight:
            guard self.configure.coupleTitle.count == self.barView.count else {
                fatalError("框架内部数据处理错误，不给予拯救")
            }
            let labelHeight = axis.bounds.height / CGFloat(self.configure.coupleTitle.count)
            var labelSpace = labelHeight / 10
            labelSpace = min(labelSpace, 4)
            var frontView: DisplayLabel?
            for labelView in self.coupleTitleView {
                guard let front = frontView else {
                    labelView.snp.updateConstraints{
                        make in
                        make.right.equalTo(axis.snp.left).offset(0 - self.labelViewWidthSpace)
                        make.bottom.equalTo(axis.snp.bottom).offset(0 - labelSpace / 2)
                        make.height.equalTo(labelHeight - labelSpace)
                        make.width.equalTo(self.leftViewWidth)
                    }
                    frontView = labelView
                    continue
                }
                labelView.snp.updateConstraints{
                    make in
                    make.right.equalTo(axis.snp.left).offset(0 - self.labelViewWidthSpace)
                    make.bottom.equalTo(front.snp.top).offset(0 - labelSpace)
                    make.height.equalTo(labelHeight - labelSpace)
                    make.width.equalTo(self.leftViewWidth)
                }
                frontView = labelView
            }
        }
    }
    
}
