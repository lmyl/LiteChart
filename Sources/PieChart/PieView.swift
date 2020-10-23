//
//  PieView.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/8.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit

class PieView: UIView {
    private let configure: PieViewConfigure
    
    private var sectorViews: [PieSectorView] = []
    private var insideAnimationStatus: LiteChartAnimationStatus = .ready
    
    private let animationExpandKey = "animationExpandKey"
    
    init(configure: PieViewConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
        insertSectorView()
        
        updateSectorViewStaticConstraints()
    }
    
    required init?(coder: NSCoder) {
        self.configure = PieViewConfigure.emptyConfigure
        super.init(coder: coder)
        insertSectorView()
        
        updateSectorViewStaticConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    private func insertSectorView() {
        for sector in self.sectorViews {
            sector.removeFromSuperview()
        }
        self.sectorViews = []
        for configure in self.configure.pieSectorViewConfigures {
            let sectorView = PieSectorView(configure: configure)
            self.sectorViews.append(sectorView)
            self.addSubview(sectorView)
        }
    }
    
    private func updateSectorViewStaticConstraints() {
        for sectorView in self.sectorViews {
            sectorView.snp.remakeConstraints{
                make in
                make.center.equalToSuperview()
                make.width.equalToSuperview()
                make.height.equalToSuperview()
            }
        }
    }
}

extension PieView: LiteChartAnimatable {
    func startAnimation(animation: LiteChartAnimationInterface) {
        guard self.insideAnimationStatus == .cancel || self.insideAnimationStatus == .ready || self.insideAnimationStatus == .finish else {
            return
        }
        guard case .base(let duration) = animation.animationType else {
            return
        }
        guard self.sectorViews.count >= 1 else {
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
        let animationExpand = animation.animationType.quickAnimation(keyPath: "strokeEnd")
        animationExpand.fromValue = 0
        animationExpand.toValue = 1
        animationExpand.fillMode = animation.fillModel
        animationExpand.beginTime = current + animation.delay
        animationExpand.timingFunction = animation.timingFunction
        animationExpand.delegate = self
        animationExpand.duration = duration
        
        self.layer.syncTimeSystemToFather()
        self.layer.mask = maskLayer
        maskLayer.add(animationExpand, forKey: animationExpandKey)
        
        self.insideAnimationStatus = .running
    }
    
    func stopAnimation() {
        guard self.insideAnimationStatus == .running || self.insideAnimationStatus == .pause else {
            return
        }
        self.layer.removeAnimation(forKey: animationExpandKey)
        self.layer.syncTimeSystemToFather()
        self.insideAnimationStatus = .cancel
    }
    
    func pauseAnimation() {
        guard self.insideAnimationStatus == .running else {
            return
        }
        let current = CACurrentMediaTime()
        let pauseTime = (current - self.layer.beginTime) * Double(self.layer.speed) + self.layer.timeOffset
        self.layer.speed = 0
        self.layer.timeOffset = pauseTime
        self.insideAnimationStatus = .pause
    }
    
    func continueAnimation() {
        guard self.insideAnimationStatus == .pause else {
            return
        }
        let current = CACurrentMediaTime()
        self.layer.beginTime = current
        self.layer.speed = 1
        self.insideAnimationStatus = .running
    }
    
    var animationStatus: LiteChartAnimationStatus {
        self.insideAnimationStatus
    }
    
}

extension PieView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.layer.mask = nil
        if self.insideAnimationStatus != .cancel {
            self.insideAnimationStatus = .finish
        }
    }
}
