//
//  PieLineView.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/10/23.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit

class PieLineView: UIView {
    private let configure: PieLineViewConfigure
    private var lineLayers: [CAShapeLayerWithTag] = []
    private var pieView: PieView?
    private let lineLayerDelegate: PieLineViewLayerDelegate
    
    let notificationKey = "notificationPointChangedWithIndex"
    
    private var insideAnimationStatus: LiteChartAnimationStatus = .ready
    private var completeAnimationCount = 0
    private let animationGrowKey = "animationGrowKey"
    
    init(configure: PieLineViewConfigure) {
        self.configure = configure
        self.lineLayerDelegate = PieLineViewLayerDelegate(configure: configure)
        super.init(frame: .zero)
        insertPieView()
        insertLineLayer()
        
        updatePieViewStaticConstraints()
    }
    
    required init?(coder: NSCoder) {
        self.configure = .emptyCongfigure
        self.lineLayerDelegate = PieLineViewLayerDelegate(configure: configure)
        super.init(coder: coder)
        insertPieView()
        insertLineLayer()
        
        updatePieViewStaticConstraints()
    }
    
    private func insertLineLayer() {
        guard self.configure.isShowLine else {
            return
        }
        for index in 0 ..< self.configure.pieNumber {
            let newLayer = CAShapeLayerWithTag()
            newLayer.tag = index
            newLayer.delegate = self.lineLayerDelegate
            self.layer.addSublayer(newLayer)
            self.lineLayers.append(newLayer)
        }
    }
    
    private func insertPieView() {
        if let view = self.pieView {
            view.removeFromSuperview()
            self.pieView = nil
        }
        let view = PieView(configure: self.configure.pieViewConfigure)
        self.pieView = view
        self.addSubview(view)
    }
    
    private func updatePieViewStaticConstraints() {
        guard let pieView = self.pieView else {
            return
        }
        pieView.snp.remakeConstraints{
            make in
            make.center.equalToSuperview()
            make.width.equalTo(0)
            make.height.equalTo(0)
        }
    }
    
    private func updatePieViewDynamicConstraints() {
        guard let pieView = self.pieView else {
            return
        }
        pieView.snp.updateConstraints{
            make in
            if self.configure.isShowLine {
                make.width.equalTo(self.bounds.width - 2 * self.polylineSegmentLength)
                make.height.equalTo(self.bounds.height - 2 * self.polylineSegmentLength)
            } else {
                make.width.equalTo(self.bounds.width)
                make.height.equalTo(self.bounds.height)
            }
        }
    }
    
    private var polylineSegmentLength: CGFloat {
        min(self.bounds.width, self.bounds.width) / 12
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updatePieViewDynamicConstraints()
        
        for lineLayer in self.lineLayers {
            lineLayer.frame = self.layer.bounds
            lineLayer.setNeedsDisplay()
        }
    }

}

extension PieLineView: LiteChartAnimatable {
    func startAnimation(animation: LiteChartAnimationInterface) {
        guard self.animationStatus == .cancel || self.animationStatus == .ready || self.animationStatus == .finish else {
            return
        }
        startInsideAnimation(animation: animation)
        self.pieView?.startAnimation(animation: animation)
    }
    
    func startInsideAnimation(animation: LiteChartAnimationInterface) {
        guard self.insideAnimationStatus == .cancel || self.insideAnimationStatus == .ready || self.insideAnimationStatus == .finish else {
            return
        }
        guard self.configure.isShowLine && self.lineLayers.count >= 1 else {
            return
        }
        guard case .base(let duration) = animation.animationType else {
            return
        }
        let current = CACurrentMediaTime()
        let animationGrow = CABasicAnimation(keyPath: "strokeEnd")
        animationGrow.fromValue = 0
        animationGrow.toValue = 1
        animationGrow.timingFunction = .init(name: .easeIn)
        animationGrow.fillMode = animation.fillModel
        animationGrow.delegate = self
        animationGrow.duration = duration / Double(2 * self.lineLayers.count)
        
        let progress: [CGFloat] = self.configure.pieViewConfigure.pieSectorViewConfigures.map({
            $0.averageAngle
        }).map({
            $0 / 360
        })
        let time = animation.animationTimingFunction.getTimeForSortedProgress(for: progress).map({
            Double($0) * duration
        })
        for (index, lineLayer) in self.lineLayers.enumerated() {
            animationGrow.beginTime = current + animation.delay + time[index]
            lineLayer.syncTimeSystemToFather()
            lineLayer.add(animationGrow, forKey: self.animationGrowKey)
        }
        self.insideAnimationStatus = .running
    }
    
    func stopAnimation() {
        guard self.animationStatus == .running || self.animationStatus == .pause else {
            return
        }
        stopInsideAnimation()
        self.pieView?.stopAnimation()
    }
    
    func stopInsideAnimation() {
        guard self.insideAnimationStatus == .running || self.insideAnimationStatus == .pause else {
            return
        }
        for lineLayer in self.lineLayers {
            lineLayer.removeAnimation(forKey: animationGrowKey)
            lineLayer.syncTimeSystemToFather()
        }
        self.insideAnimationStatus = .cancel
    }
    
    func pauseAnimation() {
        guard self.animationStatus == .running else {
            return
        }
        pauseInsideAnimation()
        self.pieView?.pauseAnimation()
    }
    
    func pauseInsideAnimation() {
        guard self.insideAnimationStatus == .running else {
            return
        }
        let current = CACurrentMediaTime()
        for lineLayer in self.lineLayers {
            let pauseTime = (current - lineLayer.beginTime) * Double(lineLayer.speed) + lineLayer.timeOffset
            lineLayer.speed = 0
            lineLayer.timeOffset = pauseTime
        }
        self.insideAnimationStatus = .pause
    }
    
    func continueAnimation() {
        guard self.animationStatus == .pause else {
            return
        }
        continueInsideAnimation()
        self.pieView?.continueAnimation()
    }
    
    func continueInsideAnimation() {
        guard self.insideAnimationStatus == .pause else {
            return
        }
        let current = CACurrentMediaTime()
        for lineLayer in self.lineLayers {
            lineLayer.beginTime = current
            lineLayer.speed = 1
        }
        self.insideAnimationStatus = .running
    }
    
    var animationStatus: LiteChartAnimationStatus {
        if let pieView = self.pieView {
            return pieView.animationStatus.compactAnimatoinStatus(another: self.insideAnimationStatus)
        } else {
            return self.insideAnimationStatus
        }
    }
}

extension PieLineView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.completeAnimationCount += 1
        if self.completeAnimationCount == self.lineLayers.count {
            self.completeAnimationCount = 0
            if self.insideAnimationStatus != .cancel {
                self.insideAnimationStatus = .finish
            }
        }
    }
}
