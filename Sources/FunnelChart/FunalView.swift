//
//  FunalView.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/5.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit

class FunalView: LiteChartContentView {
    private var configure: FunalViewConfigure
    private var funalFloorViews: [FunalFloorView] = []
    
    private let animationKey = "down"
    private var insideAnimationStatus: LiteChartAnimationStatus = .ready
    private var animationCompleteCount = 0
    override var animationStatus: LiteChartAnimationStatus {
        return insideAnimationStatus
    }
    
    init(configure: FunalViewConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
        self.insertFunalFloorViews()
        
        updateFunalFloorViewStaticConstraint()
    }
    
    required init?(coder: NSCoder) {
        self.configure = .emptyconfigure
        super.init(coder: coder)
        self.insertFunalFloorViews()
        
        updateFunalFloorViewStaticConstraint()
    }
    
    override func layoutSubviews() {
        stopAnimation()
        
        super.layoutSubviews()
        
        updateFunalFloorViewDynamicConstraint()
    }
    
    private func insertFunalFloorViews() {
        for view in self.funalFloorViews {
            view.removeFromSuperview()
        }
        self.funalFloorViews = []
        for configure in self.configure.models {
            let floorView = FunalFloorView(configure: configure)
            self.insertSubview(floorView, at: 0)
            self.funalFloorViews.append(floorView)
        }
    }
    
    private func updateFunalFloorViewDynamicConstraint() {
        guard !self.funalFloorViews.isEmpty else {
            return
        }
        let fatherRect = self.bounds
        let floorViewHeight = fatherRect.height / CGFloat(self.funalFloorViews.count)
        for (index, floorView) in self.funalFloorViews.enumerated() {
            let originY = fatherRect.origin.y + CGFloat(index) * floorViewHeight
            let centerY = originY + floorViewHeight / 2
            floorView.snp.updateConstraints{
                make in
                make.centerY.equalTo(centerY)
                make.height.equalTo(floorViewHeight)
            }
        }
    }
    
    private func updateFunalFloorViewStaticConstraint() {
        for floorView in self.funalFloorViews {
            floorView.snp.remakeConstraints{
                make in
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.height.equalTo(0)
                make.centerY.equalTo(0)
            }
        }
    }
    
    override func pauseAnimation() {
        guard self.insideAnimationStatus == .running else {
            return
        }
        let current = CACurrentMediaTime()
        for floorView in self.funalFloorViews {
            let pauseTime = (current - floorView.layer.beginTime) * Double(floorView.layer.speed) + floorView.layer.timeOffset
            floorView.layer.speed = 0
            floorView.layer.timeOffset = pauseTime
        }
        self.insideAnimationStatus = .pause
    }
    
    override func stopAnimation() {
        guard self.insideAnimationStatus == .running || self.insideAnimationStatus == .pause else {
            return
        }
        for floorView in self.funalFloorViews {
            floorView.layer.removeAnimation(forKey: animationKey)
            floorView.layer.syncTimeSystemToFather()
        }
        self.insideAnimationStatus = .cancel
    }
    
    override func continueAnimation() {
        guard self.insideAnimationStatus == .pause else {
            return
        }
        let current = CACurrentMediaTime()
        for floorView in self.funalFloorViews {
            floorView.layer.beginTime = current
            floorView.layer.speed = 1
        }
        self.insideAnimationStatus = .running
    }
    
    override func startAnimation(animation: LiteChartAnimationInterface) {
        guard self.funalFloorViews.count >= 1 && (self.insideAnimationStatus == .finish || self.insideAnimationStatus == .cancel || self.insideAnimationStatus == .ready)  else {
            return
        }
        let fatherRect = self.bounds
        let floorViewHeight = fatherRect.height / CGFloat(self.funalFloorViews.count)
        let initCenterY = fatherRect.origin.y + floorViewHeight / 2
        let keyPath = "position.y"
        
        let currentTime = CACurrentMediaTime()
        let down: CABasicAnimation
        switch animation.animationType {
        case .base:
            down = CABasicAnimation(keyPath: keyPath)
        case .spring(let damping, let mass, let stiffness, let initalVelocity):
            let springDown = CASpringAnimation(keyPath: keyPath)
            springDown.damping = damping
            springDown.mass = mass
            springDown.stiffness = stiffness
            springDown.initialVelocity = initalVelocity
            springDown.duration = springDown.settlingDuration
            down = springDown
        }
        down.fromValue = initCenterY
        down.beginTime = currentTime + animation.delay
        down.fillMode = animation.fillModel
        down.timingFunction = animation.timingFunction
        down.delegate = self
        for (index, floorView) in self.funalFloorViews.enumerated() {
            if index == 0 {
                continue
            }
            down.toValue = floorView.center.y
            switch animation.animationType {
            case .base(let duration):
                down.duration = duration * Double(index) / Double(self.funalFloorViews.count - 1)
            case .spring:
                break
            }
            floorView.layer.syncTimeSystemToFather()
            floorView.layer.add(down, forKey: animationKey)
        }
        self.insideAnimationStatus = .running
    }
}

extension FunalView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.animationCompleteCount += 1
        if self.animationCompleteCount == self.funalFloorViews.count - 1 {
            if self.insideAnimationStatus != .cancel {
                self.insideAnimationStatus = .finish
            }
            self.animationCompleteCount = 0
        }
    }
}
