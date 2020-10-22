//
//  LineValueView.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/10/13.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class LineValueView: UIView {
    private let configure: LineValueViewConfigure
    
    private var valuesView: [[DisplayLabel]] = []
    
    private var completeAnimationCount = 0
    private var insideAnimationStatus: LiteChartAnimationStatus = .ready
    private let expandAnimationKey = "ExpandKey"
    private var animationTotalCount = 0
    
    init(configure: LineValueViewConfigure) {
        self.configure = configure
        super.init(frame: .zero)
        insertValueView()
    }
    
    required init?(coder: NSCoder) {
        self.configure = .emptyConfigure
        super.init(coder: coder)
        insertValueView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateValueViewsDynamicConstraints()
    }
    
    private func insertValueView() {
        for label in self.valuesView.joined() {
            label.removeFromSuperview()
        }
        self.valuesView = []
        guard self.configure.labelConfigure.count == self.configure.points.count else {
            return
        }
        for labelConfigures in self.configure.labelConfigure {
            var result: [DisplayLabel] = []
            for labelConfigure in labelConfigures {
                let label = DisplayLabel(configure: labelConfigure)
                self.addSubview(label)
                result.append(label)
            }
            self.valuesView.append(result)
        }
    }
    
    private func updateValueViewsDynamicConstraints() {
        for (rowIndex, labels) in self.valuesView.enumerated() {
            let labelWidth = self.bounds.width / CGFloat(labels.count + 1)
            let labelHeight = self.bounds.height / 10
            let space = labelHeight / 3
            
            guard labels.count == self.configure.points[rowIndex].count else {
                fatalError("框架内部数据处理错误，不给予拯救")
            }
            
            for (index, label) in labels.enumerated() {
                let realPoint = self.convertScalePointToRealPointWtihLimit(for: self.configure.points[rowIndex][index], rect: self.bounds)
                let center = CGPoint(x: realPoint.x, y: realPoint.y - space - labelHeight / 2)
                label.snp.updateConstraints{
                    make in
                    make.center.equalTo(center)
                    make.width.equalTo(labelWidth)
                    make.height.equalTo(labelHeight)
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

extension LineValueView: LiteChartAnimatable {
    func startAnimation(animation: LiteChartAnimationInterface) {
        guard self.insideAnimationStatus == .ready || self.insideAnimationStatus == .cancel || self.insideAnimationStatus == .finish else {
            return
        }
        guard case .base(let duration) = animation.animationType else {
            return
        }
        let totalCount = self.valuesView.joined().count
        guard totalCount >= 1 else {
            return
        }
        self.animationTotalCount = totalCount
        let current = CACurrentMediaTime()
        let animationKey = "transform.scale"
        
        let keyAnimation = CAKeyframeAnimation(keyPath: animationKey)
        keyAnimation.values = [0, 0, 1, 1]
        keyAnimation.beginTime = current + animation.delay
        keyAnimation.fillMode = animation.fillModel
        keyAnimation.timingFunction = animation.timingFunction
        keyAnimation.duration = duration
        keyAnimation.delegate = self
        
        for values in self.valuesView {
            for (index, value) in values.enumerated() {
                let startTime: Double
                let endTime: Double
                if index == 0 {
                    if values.count == 1 {
                        startTime = 0
                        endTime = 1
                    } else {
                        startTime = 0
                        endTime = 1.0 / (2 * Double(values.count - 1))
                    }
                } else if index == values.count - 1 {
                    startTime = 1 - 1.0 / (2 * Double(values.count - 1))
                    endTime = 1
                } else {
                    startTime = (4 * Double(index) - 1) / (4 * Double(values.count - 1))
                    endTime = (4 * Double(index) + 1) / (4 * Double(values.count - 1))
                }
                keyAnimation.keyTimes = [0 ,NSNumber(value: startTime), NSNumber(value: endTime), 1,]
                value.layer.syncTimeSystemToFather()
                value.layer.add(keyAnimation, forKey: self.expandAnimationKey)
            }
        }
        
        self.insideAnimationStatus = .running
    }
    
    func stopAnimation() {
        guard self.insideAnimationStatus == .running || self.insideAnimationStatus == .pause else {
            return
        }
        for values in self.valuesView {
            for value in values {
                value.layer.removeAnimation(forKey: self.expandAnimationKey)
                value.layer.syncTimeSystemToFather()
            }
        }
        self.insideAnimationStatus = .cancel
    }
    
    func pauseAnimation() {
        guard self.insideAnimationStatus == .running else {
            return
        }
        let current = CACurrentMediaTime()
        for values in self.valuesView {
            for value in values {
                let pauseTime = (current - value.layer.beginTime) * Double(value.layer.speed) + value.layer.timeOffset
                value.layer.speed = 0
                value.layer.timeOffset = pauseTime
            }
        }
        self.insideAnimationStatus = .pause
    }
    
    func continueAnimation() {
        guard self.insideAnimationStatus == .pause else {
            return
        }
        let current = CACurrentMediaTime()
        for values in self.valuesView {
            for value in values {
                value.layer.beginTime = current
                value.layer.speed = 1
            }
        }
        self.insideAnimationStatus = .running
    }
    
    var animationStatus: LiteChartAnimationStatus {
        self.insideAnimationStatus
    }
    
    
}

extension LineValueView: CAAnimationDelegate {
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
