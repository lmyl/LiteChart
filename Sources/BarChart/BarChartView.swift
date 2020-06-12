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
    var coupleTitleView: [DisplayLabel] = []
    var valueView: [DisplayLabel] = []
    var barView: [BarViews] = []
    
    init(configure: BarChartViewConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
        insertAxisView()
        insertBarViews()
        insertValueTitleView()
        insertCoupleTitleView()
    }
    
    required init?(coder: NSCoder) {
        self.configure = BarChartViewConfigure()
        super.init(coder: coder)
        insertAxisView()
        insertBarViews()
        insertValueTitleView()
        insertCoupleTitleView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateAxisViewConstraints()
        updateBarViewsContraints()
        updateValueViewConstraints()
        updateCoupleTitleViewConstraints()
    }
    
    private func insertCoupleTitleView() {
        for title in self.configure.coupleTitle {
            let titleView: DisplayLabel
            switch self.configure.direction {
            case .bottomToTop:
                titleView = DisplayLabel(configure: .init(contentString: title, contentColor: self.configure.textColor))
            case .leftToRight:
                titleView = DisplayLabel(configure: .init(contentString: title, contentColor: self.configure.textColor, textAlignment: .right))
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
                valueView = DisplayLabel(configure: .init(contentString: value, contentColor: self.configure.textColor, textAlignment: .right))
            case .leftToRight:
                valueView = DisplayLabel(configure: .init(contentString: value, contentColor: self.configure.textColor))
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
        let axisView = AxisView(configure: .init(originPoint: original, axisColor: self.configure.borderColor, verticalDividingPoints: self.configure.yDividingPoints, horizontalDividingPoints: self.configure.xDividingPoints, borderStyle: borderStlye, borderColor: self.configure.borderColor))
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
        var coupleBarsInputDatas: [[(LiteChartDarkLightColor, CGFloat, String?)]] = Array(repeating: [], count: coupleCount)
        
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
                if let labelString = input.2 {
                    let barViewConfigure = BarViewConfigure(length: input.1, barColor: input.0, label: DisplayLabelConfigure(contentString: labelString, contentColor: self.configure.textColor, textAlignment: textAlignment), direction: self.configure.direction)
                    barViewsConfigure.append(barViewConfigure)
                } else {
                    let barViewConfigure = BarViewConfigure(length: input.1, barColor: input.0, direction: self.configure.direction)
                    barViewsConfigure.append(barViewConfigure)
                }
            }
            let barViews = BarViews(configure: .init(models: barViewsConfigure, direction: self.configure.direction))
            axis.addSubview(barViews)
            self.barView.append(barViews)
        }
    }
    
    private var leftViewWidth: CGFloat {
        let leftSpace = self.bounds.width / 10
        return min(leftSpace, 20)
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
        self.leftViewWidth + self.labelViewSpace
    }
    
    private var bottomSpace: CGFloat {
        self.bottomViewHeight + self.labelViewSpace
    }
    
    private func updateAxisViewConstraints() {
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
    
    private func updateBarViewsContraints() {
        let itemCount = self.barView.count
        guard let axis = self.axisView, itemCount > 0 else {
            return
        }
        
        var frontView: BarViews?
        
        switch self.configure.direction {
        case .bottomToTop:
            let itemWidth = axis.bounds.width / CGFloat(itemCount)
            for barView in self.barView {
                guard let front = frontView else {
                    barView.snp.updateConstraints{
                        make in
                        make.left.equalTo(axis.snp.left)
                        make.width.equalTo(itemWidth)
                        make.bottom.equalTo(axis.snp.bottom)
                        make.top.equalTo(axis.snp.top)
                    }
                    frontView = barView
                    continue
                }
                barView.snp.updateConstraints{
                    make in
                    make.left.equalTo(front.snp.right)
                    make.width.equalTo(itemWidth)
                    make.bottom.equalTo(axis.snp.bottom)
                    make.top.equalTo(axis.snp.top)
                }
                frontView = barView
            }
        case .leftToRight:
            let itemHeight = axis.bounds.height / CGFloat(itemCount)
            for barView in self.barView {
                guard let front = frontView else {
                    barView.snp.updateConstraints{
                        make in
                        make.left.equalTo(axis.snp.left)
                        make.height.equalTo(itemHeight)
                        make.bottom.equalTo(axis.snp.bottom)
                        make.right.equalTo(axis.snp.right)
                    }
                    frontView = barView
                    continue
                }
                barView.snp.updateConstraints{
                    make in
                    make.left.equalTo(axis.snp.left)
                    make.height.equalTo(itemHeight)
                    make.bottom.equalTo(front.snp.top)
                    make.right.equalTo(axis.snp.right)
                }
                frontView = barView
            }
        }
    }
    
    private func updateValueViewConstraints() {
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
                let center = CGPoint(x: self.bounds.origin.x + self.leftViewWidth / 2, y: endPoint.y)
                var labelHeight = axis.bounds.height / CGFloat(self.configure.valueTitle.count)
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
                let center = CGPoint(x: endPoint.x, y: self.bounds.origin.y + self.bounds.height - self.bottomViewHeight / 2)
                var labelWidth = axis.bounds.width / CGFloat(self.configure.valueTitle.count)
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
    
    private func updateCoupleTitleViewConstraints() {
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
                        make.top.equalTo(axis.snp.bottom).offset(self.labelViewSpace)
                        make.height.equalTo(self.bottomViewHeight)
                        make.width.equalTo(labelWidth - labelSpace)
                    }
                    frontView = labelView
                    continue
                }
                labelView.snp.updateConstraints{
                    make in
                    make.left.equalTo(front.snp.right).offset(labelSpace)
                    make.top.equalTo(axis.snp.bottom).offset(self.labelViewSpace)
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
                        make.left.equalToSuperview()
                        make.bottom.equalTo(axis.snp.bottom).offset(0 - labelSpace / 2)
                        make.height.equalTo(labelHeight - labelSpace)
                        make.width.equalTo(self.leftViewWidth)
                    }
                    frontView = labelView
                    continue
                }
                labelView.snp.updateConstraints{
                    make in
                    make.left.equalToSuperview()
                    make.bottom.equalTo(front.snp.top).offset(0 - labelSpace)
                    make.height.equalTo(labelHeight - labelSpace)
                    make.width.equalTo(self.leftViewWidth)
                }
                frontView = labelView
            }
        }
    }
    
}
