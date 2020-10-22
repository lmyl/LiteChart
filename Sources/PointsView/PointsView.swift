//
//  PointsView.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/20.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit
import SnapKit

class PointsView: UIView {
    private let configure: PointsViewConfigure
    private var points: [UIView] = []
    
    private var completeAnimationCount = 0
    private var insideAnimationStatus: LiteChartAnimationStatus = .ready
    private let expandAnimationKey = "ExpandAndLiftKey"
    
    init(configure: PointsViewConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
        insertPoints()
    }
    
    required init?(coder: NSCoder) {
        self.configure = PointsViewConfigure.emptyConfigure
        super.init(coder: coder)
        insertPoints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updatePointsDynmaicConstrints()
    }
    
    private func insertPoints() {
        for uiView in self.points {
            uiView.removeFromSuperview()
        }
        self.points = []
        for point in self.configure.points {
            let uiview = LegendFactory.shared.makeNewLegend(from: point.legendConfigure)
            var opacity = point.opacity
            if opacity > 1 {
                opacity = 1
            } else if opacity < 0 {
                opacity = 0
            }
            
            uiview.alpha = opacity
            self.addSubview(uiview)
            self.points.append(uiview)
        }
    }
    
    private func updatePointsDynmaicConstrints() {
        guard self.points.count == self.configure.points.count else {
            fatalError("框架内部数据处理错误，不给予拯救")
        }
        for (index, point) in self.points.enumerated() {
            var pointLocation = self.configure.points[index].location
            if pointLocation.x < 0 {
                pointLocation.x = 0
            } else if pointLocation.x > 1 {
                pointLocation.x = 1
            }
            
            if pointLocation.y < 0 {
                pointLocation.y = 1
            } else if pointLocation.y > 1 {
                pointLocation.y = 0
            } else {
                pointLocation.y = 1 - pointLocation.y
            }
            
            let center = CGPoint(x: self.bounds.width * pointLocation.x + self.bounds.origin.x, y: self.bounds.height * pointLocation.y + self.bounds.origin.y)
            
            let initWidth = self.bounds.width / 40
            let initHeight = self.bounds.height / 40
            let initLength = min(initWidth, initHeight)
            var scaleSize = self.configure.points[index].size
            if scaleSize < 1 {
                scaleSize = 1
            }
            let finalLength = initLength * scaleSize
            
            point.snp.updateConstraints{
                make in
                make.width.equalTo(finalLength)
                make.height.equalTo(finalLength)
                make.center.equalTo(center)
            }
        }
    }
}


extension PointsView: LiteChartAnimatable {
    func startAnimation(animation: LiteChartAnimationInterface) {
        guard self.insideAnimationStatus == .ready || self.insideAnimationStatus == .cancel || self.insideAnimationStatus == .finish else {
            return
        }
        guard self.points.count >= 1 else {
            return
        }
        let current = CACurrentMediaTime()
        let animationScaleKey = "transform.scale"
        let animationPositionYKey = "position.y"
        let expandAnimation = animation.animationType.quickAnimation(keyPath: animationScaleKey)
        expandAnimation.fromValue = 0
        expandAnimation.toValue = 1
        
        let expandAnimationGroup = CAAnimationGroup()
        expandAnimationGroup.beginTime = current + animation.delay
        expandAnimationGroup.timingFunction = animation.timingFunction
        expandAnimationGroup.fillMode = animation.fillModel
        expandAnimationGroup.duration = expandAnimation.duration
        expandAnimationGroup.delegate = self
        for point in self.points {
            let liftAnimation = animation.animationType.quickAnimation(keyPath: animationPositionYKey)
            liftAnimation.fromValue = self.layer.bounds.maxY
            liftAnimation.toValue = point.center.y
            expandAnimationGroup.animations = [liftAnimation, expandAnimation]
            point.layer.syncTimeSystemToFather()
            point.layer.add(expandAnimationGroup, forKey: expandAnimationKey)
        }
        
        self.insideAnimationStatus = .running
    }
    
    func stopAnimation() {
        guard self.insideAnimationStatus == .running || self.insideAnimationStatus == .pause else {
            return
        }
        for point in self.points {
            point.layer.removeAnimation(forKey: expandAnimationKey)
            point.layer.syncTimeSystemToFather()
        }
        self.insideAnimationStatus = .cancel
    }
    
    func pauseAnimation() {
        guard self.insideAnimationStatus == .running else {
            return
        }
        let current = CACurrentMediaTime()
        for point in self.points {
            let pauseTime = (current - point.layer.beginTime) * Double(point.layer.speed) + point.layer.timeOffset
            point.layer.speed = 0
            point.layer.timeOffset = pauseTime
        }
        self.insideAnimationStatus = .pause
    }
    
    func continueAnimation() {
        guard self.insideAnimationStatus == .pause else {
            return
        }
        let current = CACurrentMediaTime()
        for point in self.points {
            point.layer.beginTime = current
            point.layer.speed = 1
        }
        self.insideAnimationStatus = .running
    }
    
    var animationStatus: LiteChartAnimationStatus {
        self.insideAnimationStatus
    }
}

extension PointsView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.completeAnimationCount += 1
        if self.completeAnimationCount == self.points.count {
            if self.insideAnimationStatus != .cancel {
                self.insideAnimationStatus = .finish
            }
            self.completeAnimationCount = 0
        }
    }
}
