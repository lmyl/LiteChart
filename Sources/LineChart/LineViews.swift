//
//  LineViews.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/17.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit
import SnapKit

class LineViews: UIView {
    private let configure: LineViewsConfigure
    
    private var lineViews: [LineView] = []
    private var lineLegendView: LineLegendView?
    private var lineValueView: LineValueView?
    
    init(configure: LineViewsConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
        self.insertLineViews()
        self.insertLineLegendView()
        self.insertLineValueView()
        
        updateLineViewsStaticConstraints()
        updateLineValueViewStaticConstraints()
        updateLineLegendViewStaticConstraints()
    }
    
    required init?(coder: NSCoder) {
        self.configure = LineViewsConfigure.emptyConfigure
        super.init(coder: coder)
        self.insertLineViews()
        self.insertLineLegendView()
        self.insertLineValueView()
        
        updateLineViewsStaticConstraints()
        updateLineValueViewStaticConstraints()
        updateLineLegendViewStaticConstraints()
    }
    
    private func insertLineViews() {
        for line in self.lineViews {
            line.removeFromSuperview()
        }
        self.lineViews = []
        for model in self.configure.models {
            let line = LineView(configure: model)
            self.addSubview(line)
            self.lineViews.append(line)
        }
    }
    
    private func insertLineLegendView() {
        if let legendView = self.lineLegendView {
            legendView.removeFromSuperview()
            self.lineLegendView = nil
        }
        let legendView = LineLegendView(configure: self.configure.legendModel)
        self.lineLegendView = legendView
        self.addSubview(legendView)
    }
    
    private func insertLineValueView() {
        if let valueView = self.lineValueView {
            valueView.removeFromSuperview()
            self.lineValueView = nil
        }
        guard self.configure.isShowLabel else {
            return
        }
        let lineValues = LineValueView(configure: self.configure.valueModel)
        self.lineValueView = lineValues
        self.addSubview(lineValues)
        self.bringSubviewToFront(lineValues)
    }
    
    private func updateLineValueViewStaticConstraints() {
        guard let lineValue = self.lineValueView else {
            return
        }
        lineValue.snp.remakeConstraints({
            make in
            make.trailing.leading.bottom.top.equalToSuperview()
        })
    }
    
    private func updateLineViewsStaticConstraints() {
        for line in self.lineViews {
            line.snp.remakeConstraints{
                make in
                make.trailing.leading.bottom.top.equalToSuperview()
            }
        }
    }
    
    private func updateLineLegendViewStaticConstraints() {
        guard let legendView = self.lineLegendView else {
            return
        }
        legendView.snp.remakeConstraints{
            make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
}

extension LineViews: LiteChartAnimatable {
    func startAnimation(animation: LiteChartAnimationInterface) {
        guard animationStatus == .ready || animationStatus == .cancel || animationStatus == .finish else {
            return
        }
        for line in self.lineViews {
            line.startAnimation(animation: animation)
        }
        if let lineLegend = self.lineLegendView {
            lineLegend.startAnimation(animation: animation)
        }
        if let lineValue = self.lineValueView {
            lineValue.startAnimation(animation: animation)
        }
    }
    
    func stopAnimation() {
        guard animationStatus == .running || animationStatus == .pause else {
            return
        }
        for line in self.lineViews {
            line.stopAnimation()
        }
        if let lineLegend = self.lineLegendView {
            lineLegend.stopAnimation()
        }
        if let lineValue = self.lineValueView {
            lineValue.stopAnimation()
        }
    }
    
    func pauseAnimation() {
        guard animationStatus == .running else {
            return
        }
        for line in self.lineViews {
            line.pauseAnimation()
        }
        if let lineLegend = self.lineLegendView {
            lineLegend.pauseAnimation()
        }
        if let lineValue = self.lineValueView {
            lineValue.pauseAnimation()
        }
    }
    
    func continueAnimation() {
        guard animationStatus == .pause else {
            return
        }
        for line in self.lineViews {
            line.continueAnimation()
        }
        if let lineLegend = self.lineLegendView {
            lineLegend.continueAnimation()
        }
        if let lineValue = self.lineValueView {
            lineValue.continueAnimation()
        }
    }
    
    var animationStatus: LiteChartAnimationStatus {
        var result = LiteChartAnimationStatus.ready
        result = self.lineViews.reduce(result, {
            $0.compactAnimatoinStatus(another: $1.animationStatus)
        })
        if let lineValue = self.lineValueView {
            result = result.compactAnimatoinStatus(another: lineValue.animationStatus)
        }
        if let lineLegend = self.lineLegendView {
            result = result.compactAnimatoinStatus(another: lineLegend.animationStatus)
        }
        return result
    }
}
