//
//  PieViews.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/8.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit

class PieViews: LiteChartContentView {
    private let configure: PieViewsConfigure
    
    private var pieViews: [PieView] = []
        
    private let animationExpandKey = "expand"
    private let animationOpacityKey = "opacity"
    private let maskAnimationName = "maskAnimation"
    private var insideAnimationStatus: LiteChartAnimationStatus = .ready
    private var animationCompleteCount = 0
    override var animationStatus: LiteChartAnimationStatus {
        return insideAnimationStatus
    }
    
    init(configure: PieViewsConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
        insertPieView()
        
        updatePieViewsStaticConstraints()
    }
    
    required init?(coder: NSCoder) {
        self.configure = PieViewsConfigure.emptyConfigure
        super.init(coder: coder)
        insertPieView()
        
        updatePieViewsStaticConstraints()
    }
    
    override func layoutSubviews() {
        stopAnimation()
        
        super.layoutSubviews()
    }
    
    private func insertPieView() {
        for pie in self.pieViews {
            pie.removeFromSuperview()
        }
        self.pieViews = []
        for pieConfigure in self.configure.models {
            let pie = PieView(configure: pieConfigure)
            self.addSubview(pie)
            self.pieViews.append(pie)
        }
    }
    
    private func updatePieViewsStaticConstraints() {
        for pie in self.pieViews {
            pie.snp.remakeConstraints{
                make in
                make.trailing.leading.top.bottom.equalToSuperview()
            }
        }
    }
    
    override func startAnimation(animation: LiteChartAnimationInterface) {
        guard self.insideAnimationStatus == .cancel || self.insideAnimationStatus == .finish || self.insideAnimationStatus == .ready else {
            return
        }
        guard case .base(let duration) = animation.animationType else {
            return
        }
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.layer.bounds
        maskLayer.strokeColor = UIColor.black.cgColor
        maskLayer.fillColor = UIColor.clear.cgColor
        
        let center = CGPoint(x: self.layer.bounds.width / 2, y: self.layer.bounds.height / 2)
        let maxDiameter = max(self.layer.bounds.width, self.layer.bounds.height) / 2
        maskLayer.lineWidth = maxDiameter
        maskLayer.path = UIBezierPath(arcCenter: center, radius: maxDiameter / 2, startAngle: 0, endAngle: 2 * CGFloat(Double.pi), clockwise: true).cgPath
        
        
        let current = CACurrentMediaTime()
        let animationExpand = CABasicAnimation(keyPath: "strokeEnd")
        animationExpand.duration = duration
        animationExpand.fromValue = 0
        animationExpand.toValue = 1
        animationExpand.fillMode = animation.fillModel
        animationExpand.beginTime = current + animation.delay
        animationExpand.timingFunction = animation.timingFunction
        animationExpand.delegate = self
        animationExpand.setValue(self.maskAnimationName, forKey: "name")
        
        let animationOpacity = CABasicAnimation(keyPath: "opacity")
        animationOpacity.duration = duration
        animationOpacity.fromValue = 0
        animationOpacity.toValue = 1
        animationOpacity.fillMode = animation.fillModel
        animationOpacity.beginTime = current + animation.delay
        animationOpacity.timingFunction = animation.timingFunction
        animationOpacity.delegate = self
        
        self.layer.syncTimeSystemToFather()
        self.layer.add(animationOpacity, forKey: animationOpacityKey)
        self.layer.mask = maskLayer
        maskLayer.add(animationExpand, forKey: animationExpandKey)
        
        self.insideAnimationStatus = .running
    }
    
    override func pauseAnimation() {
        guard self.insideAnimationStatus == .running else {
            return
        }
        let current = CACurrentMediaTime()
        let pauseTime = (current - self.layer.beginTime) * Double(self.layer.speed) + self.layer.timeOffset
        self.layer.speed = 0
        self.layer.timeOffset = pauseTime
        self.insideAnimationStatus = .pause
    }
    
    override func stopAnimation() {
        guard self.insideAnimationStatus == .running || self.insideAnimationStatus == .pause else {
            return
        }
        self.layer.removeAnimation(forKey: animationOpacityKey)
        self.layer.mask?.removeAnimation(forKey: animationExpandKey)
        self.layer.syncTimeSystemToFather()
        self.insideAnimationStatus = .cancel
    }
    
    override func continueAnimation() {
        guard self.insideAnimationStatus == .pause else {
            return
        }
        let current = CACurrentMediaTime()
        self.layer.beginTime = current
        self.layer.speed = 1
        self.insideAnimationStatus = .running
    }
}

extension PieViews: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.animationCompleteCount += 1
        if let name = anim.value(forKey: "name") as? String, name == self.maskAnimationName {
            self.layer.mask = nil
        }
        if self.animationCompleteCount == 2 {
            if self.insideAnimationStatus != .cancel {
                self.insideAnimationStatus = .finish
            }
            self.animationCompleteCount = 0
        }
    }
}
