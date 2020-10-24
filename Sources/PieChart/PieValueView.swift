//
//  PieValueView.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/10/23.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit

class PieValueView: UIView {
    private let configure: PieValueViewConfigure
    private var textViews: [DisplayLabel] = []
    private var pieLineView: PieLineView?
    private var notificationToken: NSObjectProtocol?
    
    private var insideAnimationStatus: LiteChartAnimationStatus = .ready
    private var completeAnimationCount = 0
    private let animationExpandKey = "animationExpandKey"
    
    init(configure: PieValueViewConfigure) {
        self.configure = configure
        super.init(frame: .zero)
        insertPieLineView()
        insertTextView()
        
        updatePieLineViewStaticConstraints()
    }
    
    required init?(coder: NSCoder) {
        self.configure = .emptyConfigure
        super.init(coder: coder)
        insertPieLineView()
        insertTextView()
        
        updatePieLineViewStaticConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updatePieLineViewDynamicConstraints()
    }
    
    private func insertTextView() {
        for text in self.textViews {
            text.removeFromSuperview()
        }
        self.textViews = []
        guard self.configure.isShowLable else {
            return
        }
        for textConfigure in self.configure.displayTextConfigures {
            let displayTextView = DisplayLabel(configure: textConfigure)
            self.addSubview(displayTextView)
            self.textViews.append(displayTextView)
        }
    }
    
    private func insertPieLineView() {
        if let view = self.pieLineView {
            view.removeFromSuperview()
            self.pieLineView = nil
        }
        let newLineView = PieLineView(configure: self.configure.pieLineViewConfigure)
        self.pieLineView = newLineView
        self.addSubview(newLineView)
        self.notificationToken = NotificationCenter.default.addObserver(forName: .didComputeLabelLocationForPie, object: newLineView, queue: .main){
            [weak self] notification in
            guard let strongSelf = self else {
                return
            }
            guard let info = notification.userInfo, let lineEndPointAndIndex = info[newLineView.notificationKey] as? (Int, CGPoint) else {
                return
            }
            strongSelf.updateTextViewDynamicConstraints(for: lineEndPointAndIndex.1, index: lineEndPointAndIndex.0)
        }
    }
    
    private var labelWidth: CGFloat {
        let labelLength = self.bounds.width / 8
        return labelLength
    }

    private var labelHeight: CGFloat {
        let labelHeight = min(self.bounds.width - 2 * labelWidth, self.bounds.height) / 12
        return labelHeight
    }
    
    private func updatePieLineViewStaticConstraints() {
        guard let pieView = self.pieLineView else {
            return
        }
        pieView.snp.remakeConstraints{
            make in
            make.center.equalToSuperview()
            make.width.equalTo(0)
            make.height.equalToSuperview()
        }
    }
    
    private func updatePieLineViewDynamicConstraints() {
        guard let pieView = self.pieLineView else {
            return
        }
        pieView.snp.updateConstraints{
            make in
            if self.configure.isShowLable {
                make.width.equalTo(self.bounds.width - 2 * self.labelWidth)
            } else {
                make.width.equalTo(self.bounds.width)
            }
        }
    }
    
    private func updateTextViewDynamicConstraints(for endPoint: CGPoint, index: Int) {
        guard let pieLineView = self.pieLineView else {
            return
        }
        guard index < self.textViews.count else {
            return
        }
        guard index < self.configure.pieNumber else {
            return
        }
        let textView = self.textViews[index]
        let newPoint = pieLineView.convert(endPoint, to: self)
        let labelLength = self.labelWidth
        let labelHeight = self.labelHeight
        let centerY = newPoint.y
        let centerX: CGFloat
        if self.configure.pieLineViewConfigure.pieViewConfigure.pieSectorViewConfigures[index].isLeftSector {
            centerX = newPoint.x - labelLength / 2
        } else {
            centerX = newPoint.x + labelLength / 2
        }
        let center = CGPoint(x: centerX, y: centerY)
        textView.snp.updateConstraints{
            make in
            make.center.equalTo(center)
            make.height.equalTo(labelHeight)
            make.width.equalTo(labelLength)
        }
        textView.setNeedsLayout()
        textView.layoutIfNeeded()
    }
    
    deinit {
        self.clearNotification()
    }

    private func clearNotification() {
        guard let token = self.notificationToken else {
            return
        }
        NotificationCenter.default.removeObserver(token)
        self.notificationToken = nil
    }
}

extension PieValueView: LiteChartAnimatable {
    func startAnimation(animation: LiteChartAnimationInterface) {
        guard self.animationStatus == .cancel || self.animationStatus == .ready || self.animationStatus == .finish else {
            return
        }
        startInsideAnimation(animation: animation)
        self.pieLineView?.startAnimation(animation: animation)
    }
    
    func startInsideAnimation(animation: LiteChartAnimationInterface) {
        guard self.insideAnimationStatus == .cancel || self.insideAnimationStatus == .ready || self.insideAnimationStatus == .finish else {
            return
        }
        guard self.configure.isShowLable && self.textViews.count >= 1 else {
            return
        }
        guard case .base(let duration) = animation.animationType else {
            return
        }
        
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
        
        let progress: [CGFloat] = self.configure.pieLineViewConfigure.pieViewConfigure.pieSectorViewConfigures.map({
            $0.averageAngle
        }).map({
            $0 / 360
        })
        let lineAnimationDuration = duration / Double(2 * self.textViews.count)
        let time = animation.animationTimingFunction.getTimeForSortedProgress(for: progress).map({
            Double($0) * duration
        })
        for (index, textView) in self.textViews.enumerated() {
            springAnimation.beginTime = current + animation.delay + time[index] + lineAnimationDuration
            textView.layer.syncTimeSystemToFather()
            textView.layer.add(springAnimation, forKey: self.animationExpandKey)
        }
        self.insideAnimationStatus = .running
    }
    
    func stopAnimation() {
        guard self.animationStatus == .running || self.animationStatus == .pause else {
            return
        }
        stopInsideAnimation()
        self.pieLineView?.stopAnimation()
    }
    
    func stopInsideAnimation() {
        guard self.insideAnimationStatus == .running || self.insideAnimationStatus == .pause else {
            return
        }
        for textView in self.textViews {
            textView.layer.removeAnimation(forKey: animationExpandKey)
            textView.layer.syncTimeSystemToFather()
        }
        self.insideAnimationStatus = .cancel
    }
    
    func pauseAnimation() {
        guard self.animationStatus == .running else {
            return
        }
        pauseInsideAnimation()
        self.pieLineView?.pauseAnimation()
    }
    
    func pauseInsideAnimation() {
        guard self.insideAnimationStatus == .running else {
            return
        }
        let current = CACurrentMediaTime()
        for textView in self.textViews {
            let pauseTime = (current - textView.layer.beginTime) * Double(textView.layer.speed) + textView.layer.timeOffset
            textView.layer.speed = 0
            textView.layer.timeOffset = pauseTime
        }
        self.insideAnimationStatus = .pause
    }
    
    func continueAnimation() {
        guard self.animationStatus == .pause else {
            return
        }
        continueInsideAnimation()
        self.pieLineView?.continueAnimation()
    }
    
    func continueInsideAnimation() {
        guard self.insideAnimationStatus == .pause else {
            return
        }
        let current = CACurrentMediaTime()
        for textView in self.textViews {
            textView.layer.beginTime = current
            textView.layer.speed = 1
        }
        self.insideAnimationStatus = .running
    }
    
    var animationStatus: LiteChartAnimationStatus {
        if let lineView = self.pieLineView {
            return lineView.animationStatus.compactAnimatoinStatus(another: self.insideAnimationStatus)
        } else {
            return self.insideAnimationStatus
        }
    }
}

extension PieValueView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.completeAnimationCount += 1
        if self.completeAnimationCount == self.textViews.count {
            if self.insideAnimationStatus != .cancel {
                self.insideAnimationStatus = .finish
            }
            self.completeAnimationCount = 0
        }
    }
}
