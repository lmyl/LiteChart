//
//  LineLegendView.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/10/20.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation
import UIKit

class LineLegendView: UIView {
    private let configure: LineLegendViewConfigure
    
    private var legendsView: [[UIView]] = []
    private var completeAnimationCount = 0
    private var insideAnimationStatus: LiteChartAnimationStatus = .ready
    private let springExpandAnimationKey = "ExpandKey"
    private var animationTotalCount = 0
    
    init(configure: LineLegendViewConfigure) {
        self.configure = configure
        super.init(frame: .zero)
        insertLegend()
    }
    
    required init?(coder: NSCoder) {
        self.configure = .emptyConfigure
        super.init(coder: coder)
        insertLegend()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateLegendsDynamicConstraints()
    }
    
    private func insertLegend() {
        for legends in self.legendsView {
            for legend in legends {
                legend.removeFromSuperview()
            }
        }
        self.legendsView = []
        guard self.configure.points.count == self.configure.legendConfigure.count else {
            return
        }
        for (index, points) in self.configure.points.enumerated() {
            var legends: [UIView] = []
            for _ in points {
                let legend = LegendFactory.shared.makeNewLegend(from: self.configure.legendConfigure[index])
                legends.append(legend)
                self.addSubview(legend)
            }
            self.legendsView.append(legends)
        }
    }
    
    private func updateLegendsDynamicConstraints() {
        guard self.configure.points.count >= 1 else {
            return
        }
        guard self.legendsView.count == self.configure.points.count else {
            fatalError("框架内部数据处理错误，不给予拯救")
        }
        let legendHeight = self.bounds.height / 20
        for (index, legends) in self.legendsView.enumerated() {
            let legendWidth = self.bounds.width / CGFloat(self.configure.points[index].count + 1)
            let legendLength = min(legendHeight, legendWidth)
            guard legends.count == self.configure.points[index].count else {
                fatalError("框架内部数据处理错误，不给予拯救")
            }
            for (indexInside, legend) in legends.enumerated() {
                let realPoint = self.convertScalePointToRealPointWtihLimit(for: self.configure.points[index][indexInside], rect: self.bounds)
                legend.snp.updateConstraints{
                    make in
                    make.center.equalTo(realPoint)
                    make.width.equalTo(legendLength)
                    make.height.equalTo(legendLength)
                }
            }
        }
        
    }
    
    private func convertScalePointToRealPointWtihLimit(for point: CGPoint, rect: CGRect) -> CGPoint {
        var realPoint = point
        if realPoint.x < 0 {
            realPoint.x = 0
        } else if realPoint.x > 1 {
            realPoint.x = 1
        }
        
        if realPoint.y < 0 {
            realPoint.y = 0
        } else if realPoint.y > 1 {
            realPoint.y = 1
        }
        realPoint = CGPoint(x: rect.width * realPoint.x + rect.origin.x, y: rect.origin.y + rect.height * (1 - realPoint.y))
        return realPoint
    }
}

extension LineLegendView: LiteChartAnimatable {
    func startAnimation(animation: LiteChartAnimationInterface) {
        guard self.insideAnimationStatus == .ready || self.insideAnimationStatus == .cancel || self.insideAnimationStatus == .finish else {
            return
        }
        self.animationTotalCount = self.legendsView.joined().count
        let current = CACurrentMediaTime()
        let animationKey = "transform.scale"
        let springExpandAnimation = CASpringAnimation(keyPath: animationKey)
        springExpandAnimation.damping = 10
        springExpandAnimation.mass = 1
        springExpandAnimation.stiffness = 100
        springExpandAnimation.initialVelocity = 0
        springExpandAnimation.duration = springExpandAnimation.settlingDuration
        springExpandAnimation.fromValue = 0
        springExpandAnimation.toValue = 1
        springExpandAnimation.beginTime = current + animation.delay
        springExpandAnimation.fillMode = animation.fillModel
        springExpandAnimation.timingFunction = animation.timingFunction
        springExpandAnimation.delegate = self
        
        for legends in self.legendsView {
            for legend in legends {
                legend.layer.syncTimeSystemToFather()
                legend.layer.add(springExpandAnimation, forKey: self.springExpandAnimationKey)
            }
        }
        
        self.insideAnimationStatus = .running
    }
    
    func stopAnimation() {
        guard self.insideAnimationStatus == .running || self.insideAnimationStatus == .pause else {
            return
        }
        for legends in self.legendsView {
            for legend in legends {
                legend.layer.removeAnimation(forKey: self.springExpandAnimationKey)
                legend.layer.syncTimeSystemToFather()
            }
        }
        self.insideAnimationStatus = .cancel
    }
    
    func pauseAnimation() {
        guard self.insideAnimationStatus == .running else {
            return
        }
        let current = CACurrentMediaTime()
        for legends in self.legendsView {
            for legend in legends {
                let pauseTime = (current - legend.layer.beginTime) * Double(legend.layer.speed) + legend.layer.timeOffset
                legend.layer.speed = 0
                legend.layer.timeOffset = pauseTime
            }
        }
        self.insideAnimationStatus = .pause
    }
    
    func continueAnimation() {
        guard self.insideAnimationStatus == .pause else {
            return
        }
        let current = CACurrentMediaTime()
        for legends in self.legendsView {
            for legend in legends {
                legend.layer.beginTime = current
                legend.layer.speed = 1
            }
        }
        self.insideAnimationStatus = .running
    }
    
    var animationStatus: LiteChartAnimationStatus {
        insideAnimationStatus
    }
}

extension LineLegendView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.completeAnimationCount += 1
        if self.completeAnimationCount == self.animationTotalCount {
            if self.insideAnimationStatus != .cancel {
                self.insideAnimationStatus = .finish
            }
            self.completeAnimationCount = 0
            self.animationTotalCount = 0
        }
    }
}
