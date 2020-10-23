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
    private let springExpandAnimationKey = "SpringExpandKey"
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
        guard case .base(let duration) = animation.animationType else {
            return
        }
        let totalCount = self.legendsView.joined().count
        guard totalCount >= 1 else {
            return
        }
        self.animationTotalCount = totalCount
        let current = CACurrentMediaTime()
        let animationKey = "transform.scale"
        let springAnimation = CASpringAnimation(keyPath: animationKey)
        springAnimation.initialVelocity = 10
        springAnimation.mass = 1
        springAnimation.damping = 10
        springAnimation.stiffness = 100
        springAnimation.fromValue = 0
        springAnimation.toValue = 1
        springAnimation.fillMode = animation.fillModel
        springAnimation.duration = springAnimation.settlingDuration
        springAnimation.delegate = self
        
        // 之前的guard和参数校验时已经保证这里的数组必然有值
        let progress: [CGFloat]
        let simple = self.legendsView[0]
        if simple.count == 1 {
            progress = [0]
        } else {
            progress = Array(stride(from: 0, through: 1, by: 1 / CGFloat(simple.count - 1)))
        }
        let time = animation.animationTimingFunction.getTimeForSortedProgress(for: progress).map({
            Double($0) * duration
        })
        for legends in self.legendsView {
            for (index, legend) in legends.enumerated() {
                springAnimation.beginTime = current + animation.delay + time[index]
                legend.layer.syncTimeSystemToFather()
                legend.layer.add(springAnimation, forKey: self.springExpandAnimationKey)
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
