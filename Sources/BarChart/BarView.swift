//
//  BarView.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/11.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit
import SnapKit

class BarView: UIView {
    private let configure: BarViewConfigure
    
    private var bar: UIView?
    private var label: DisplayLabel?
    
    private var insideAnimationStatus: LiteChartAnimationStatus = .ready
    private let animationGrowKey = "Grow"
    private var animationCompleteCount = 0
    
    init(configure: BarViewConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
        insertBar()
        insertLabel()
        
        updateBarStaticConstrints()
        updateLabelStaticConstraints()
    }
    
    required init?(coder: NSCoder) {
        self.configure = BarViewConfigure.emptyConfigure
        super.init(coder: coder)
        insertBar()
        insertLabel()
        
        updateBarStaticConstrints()
        updateLabelStaticConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateBarDynamicConstraints()
        updateLabelDynamicConstraints()
    }
    
    private func insertBar() {
        if let bar = self.bar {
            bar.removeFromSuperview()
            self.bar = nil
        }
        let bar = UIView()
        bar.backgroundColor = self.configure.barColor.color
        self.bar = bar
        self.addSubview(bar)
    }
    
    
    private func insertLabel() {
        if let label = self.label {
            label.removeFromSuperview()
            self.label = nil
        }
        guard self.configure.isShowLabel else {
            return
        }
        let label = DisplayLabel(configure: self.configure.label)
        self.addSubview(label)
        self.label = label
    }
    
    private func updateBarDynamicConstraints() {
        guard let bar = self.bar else {
            return
        }
        bar.backgroundColor = self.configure.barColor.color
        switch self.configure.direction {
        case .bottomToTop:
            let length = self.bounds.height * self.configure.length
            bar.snp.updateConstraints{
                make in
                make.height.equalTo(length)
            }
        case .leftToRight:
            let length = self.bounds.width * self.configure.length
            bar.snp.updateConstraints{
                make in
                make.width.equalTo(length)
            }
        }
        
    }
    
    private func updateBarStaticConstrints() {
        guard let bar = self.bar else {
            return
        }
        bar.backgroundColor = self.configure.barColor.color
        switch self.configure.direction {
        case .bottomToTop:
            bar.snp.remakeConstraints{
                make in
                make.bottom.equalToSuperview()
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.height.equalTo(0)
            }
        case .leftToRight:
            bar.snp.remakeConstraints{
                make in
                make.bottom.equalToSuperview()
                make.leading.equalToSuperview()
                make.width.equalTo(0)
                make.top.equalToSuperview()
            }
        }
    }
    
    private func updateLabelStaticConstraints() {
        guard let label = self.label else {
            return
        }
        guard let bar = self.bar else {
            return
        }
        switch self.configure.direction {
        case .bottomToTop:
            label.snp.remakeConstraints{
                make in
                make.bottom.equalTo(bar.snp.top)
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.height.equalTo(0)
            }
        case .leftToRight:
            label.snp.remakeConstraints{
                make in
                make.bottom.equalToSuperview()
                make.leading.equalTo(bar.snp.trailing).priority(750)
                make.trailing.equalToSuperview()
                make.height.equalToSuperview()
            }
        }
    }
    
    private func updateLabelDynamicConstraints() {
        guard let label = self.label else {
            return
        }
        guard let bar = self.bar else {
            return
        }
        switch self.configure.direction {
        case .bottomToTop:
            var height = self.bounds.height / 15
            height = min(height, self.bounds.width * 2)
            label.snp.updateConstraints{
                make in
                make.bottom.equalTo(bar.snp.top)
                make.height.equalTo(height)
            }
        case .leftToRight:
            let space = self.bounds.width / 30
            label.snp.updateConstraints{
                make in
                make.leading.equalTo(bar.snp.trailing).offset(space).priority(750)
            }
        }
    }
}

extension BarView: LiteChartAnimatable {
    func startAnimation(animation: LiteChartAnimationInterface) {
        guard let bar = self.bar else {
            return
        }
        guard self.insideAnimationStatus == .finish || self.insideAnimationStatus == .cancel || self.insideAnimationStatus == .ready else {
            return
        }
        
        let boundsSizeKey = "bounds.size"
        let positionXKey = "position.x"
        let positionYKey = "position.y"
        
        let current = CACurrentMediaTime()
        let animationGrowGroup = CAAnimationGroup()
        let animationGrow: CABasicAnimation
        let animationPan: CABasicAnimation
        
        switch self.configure.direction {
        case .bottomToTop:
            switch animation.animationType {
            case .base(let duration):
                let dur = duration * Double(self.configure.length)
                animationGrow = CABasicAnimation(keyPath: boundsSizeKey)
                animationPan = CABasicAnimation(keyPath: positionYKey)
                animationGrowGroup.duration = dur
            case .spring:
                animationGrow = animation.animationType.quickAnimation(keyPath: boundsSizeKey)
                animationPan = animation.animationType.quickAnimation(keyPath: positionYKey)
                animationGrowGroup.duration = animationPan.duration
            }
            animationGrow.fromValue = NSValue(cgSize: CGSize(width: bar.bounds.width, height: 0))
            animationGrow.toValue = NSValue(cgSize: CGSize(width: bar.bounds.width, height: bar.bounds.height))
            animationPan.fromValue = bar.frame.maxY
            animationPan.toValue = bar.center.y
        case .leftToRight:
            switch animation.animationType {
            case .base(let duration):
                animationGrow = CABasicAnimation(keyPath: boundsSizeKey)
                animationPan = CABasicAnimation(keyPath: positionXKey)
                animationGrowGroup.duration = duration * Double(self.configure.length)
            case .spring:
                animationGrow = animation.animationType.quickAnimation(keyPath: boundsSizeKey)
                animationPan = animation.animationType.quickAnimation(keyPath: positionXKey)
                animationGrowGroup.duration = animationPan.duration
            }
            animationGrow.fromValue = NSValue(cgSize: CGSize(width: 0, height: bar.bounds.height))
            animationGrow.toValue = NSValue(cgSize: CGSize(width: bar.bounds.width, height: bar.bounds.height))
            animationPan.fromValue = bar.frame.minX
            animationPan.toValue = bar.center.x
        }
        animationGrowGroup.timingFunction = animation.timingFunction
        animationGrowGroup.fillMode = animation.fillModel
        animationGrowGroup.beginTime = current + animation.delay
        animationGrowGroup.delegate = self
        animationGrowGroup.animations = [animationPan, animationGrow]
        defer {
            bar.layer.syncTimeSystemToFather()
            bar.layer.add(animationGrowGroup, forKey: animationGrowKey)
            self.insideAnimationStatus = .running
        }
        
        guard let label = self.label else {
            return
        }
        
        let labelPositionXOrY: CGFloat
        let animationLabelGrow: CABasicAnimation
        switch self.configure.direction {
        case .bottomToTop:
            labelPositionXOrY = label.center.y
            switch animation.animationType {
            case .base(let duration):
                animationLabelGrow = CABasicAnimation(keyPath: positionYKey)
                animationLabelGrow.duration = duration * Double(self.configure.length)
            case .spring:
                animationLabelGrow = animation.animationType.quickAnimation(keyPath: positionYKey)
            }
            animationLabelGrow.fromValue = bar.frame.maxY - label.bounds.height / 2
        case .leftToRight:
            labelPositionXOrY = label.center.x
            switch animation.animationType {
            case .base(let duration):
                animationLabelGrow = CABasicAnimation(keyPath: positionXKey)
                animationLabelGrow.duration = duration * Double(self.configure.length)
            case .spring:
                animationLabelGrow = animation.animationType.quickAnimation(keyPath: positionXKey)
            }
            animationLabelGrow.fromValue = label.frame.minX - bar.frame.maxX + label.bounds.width / 2
        }
        animationLabelGrow.toValue = labelPositionXOrY
        animationLabelGrow.timingFunction = animation.timingFunction
        animationLabelGrow.fillMode = animation.fillModel
        animationLabelGrow.beginTime = current + animation.delay
        animationLabelGrow.delegate = self
        
        label.layer.syncTimeSystemToFather()
        label.layer.add(animationLabelGrow, forKey: animationGrowKey)
    }
    
    func stopAnimation() {
        guard self.insideAnimationStatus == .running || self.insideAnimationStatus == .pause else {
            return
        }
        if let bar = self.bar {
            bar.layer.removeAnimation(forKey: animationGrowKey)
            bar.layer.syncTimeSystemToFather()
        }
        if let label = self.label {
            label.layer.removeAnimation(forKey: animationGrowKey)
            label.layer.syncTimeSystemToFather()
        }
        self.insideAnimationStatus = .cancel
    }
    
    func pauseAnimation() {
        guard self.insideAnimationStatus == .running else {
            return
        }
        let current = CACurrentMediaTime()
        if let bar = self.bar {
            let pauseTime = (current - bar.layer.beginTime) * Double(bar.layer.speed) + bar.layer.timeOffset
            bar.layer.speed = 0
            bar.layer.timeOffset = pauseTime
        }
        if let label = self.label {
            let pauseTime = (current - label.layer.beginTime) * Double(label.layer.speed) + label.layer.timeOffset
            label.layer.speed = 0
            label.layer.timeOffset = pauseTime
        }
        self.insideAnimationStatus = .pause
    }
    
    func continueAnimation() {
        guard self.insideAnimationStatus == .pause else {
            return
        }
        let current = CACurrentMediaTime()
        if let bar = self.bar {
            bar.layer.beginTime = current
            bar.layer.speed = 1
        }
        if let label = self.label {
            label.layer.beginTime = current
            label.layer.speed = 1
        }
        self.insideAnimationStatus = .running
    }
    
    var animationStatus: LiteChartAnimationStatus {
        insideAnimationStatus
    }
    
}

extension BarView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.animationCompleteCount += 1
        if self.animationCompleteCount == 1 && self.label == nil {
            if self.insideAnimationStatus != .cancel {
                self.insideAnimationStatus = .finish
            }
            self.animationCompleteCount = 0
        }
        if self.animationCompleteCount == 2 && self.label != nil {
            if self.insideAnimationStatus != .cancel {
                self.insideAnimationStatus = .finish
            }
            self.animationCompleteCount = 0
        }
    }
}
