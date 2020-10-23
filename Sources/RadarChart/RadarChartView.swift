//
//  RadarChartView.swift
//  LiteChart
//
//  Created by huangxiaohui on 2020/6/23.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit
import SnapKit

class RadarChartView: LiteChartContentView {
    private var configure: RadarChartViewConfigure
    
    private var backgroundView: RadarBackgroundView?
        
    private var coupleTitles: [DisplayLabel] = []
    
    private var radarDataViews: [RadarDataView] = []
    
    private var notificationToken: NSObjectProtocol?
    
    private var completeAnimationCount = 0
    private var insideAnimationStatus: LiteChartAnimationStatus = .ready
    private let springExpandAnimationKey = "SpringExpandKey"
    
    init(configure: RadarChartViewConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
        insertRadarBackgroundView()
        insertRadarDateView()
        insertCoupleTitleView()
        
        updateRadarBackgroundViewStaticConstraints()
        updateRadarDataViewStaticConstraints()
    }
    
    required init?(coder: NSCoder) {
        self.configure = RadarChartViewConfigure.emptyConfigure
        super.init(coder: coder)
        insertRadarBackgroundView()
        insertRadarDateView()
        insertCoupleTitleView()
        
        updateRadarBackgroundViewStaticConstraints()
        updateRadarDataViewStaticConstraints()
    }
    
    override func layoutSubviews() {
        stopAnimation()
        super.layoutSubviews()
        
        updateRadarBackgroundViewDynamicConstraints()
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
    
    private var coupleTitleWidth: CGFloat {
        let width = self.bounds.width / 8
        return width
    }

    private var coupleTitleHeight: CGFloat {
        let height = self.bounds.height / 13
        return height
    }
    
    private var titleSpace: CGFloat {
        coupleTitleWidth / 4
    }
    
    private func insertCoupleTitleView() {
        for view in self.coupleTitles {
            view.removeFromSuperview()
        }
        self.coupleTitles = []
        guard self.configure.isShowCoupleTitles else {
            return
        }
        for labelConfigure in self.configure.coupleTitlesConfigure {
            let view = DisplayLabel(configure: labelConfigure)
            self.addSubview(view)
            self.coupleTitles.append(view)
        }
    }
    
    private func insertRadarDateView() {
        for view in self.radarDataViews {
            view.removeFromSuperview()
        }
        self.radarDataViews = []
        let configures = self.configure.radarDataViewsConfigure
        for dataViewConfigure in configures {
            let view = RadarDataView(configure: dataViewConfigure)
            self.addSubview(view)
            self.radarDataViews.append(view)
        }
    }
    
    private func insertRadarBackgroundView(){
        if let backgroundView = self.backgroundView {
            backgroundView.removeFromSuperview()
            self.backgroundView = nil
            self.clearNotification()
        }
        let configure = self.configure.backgroundConfigure
        let radarBackgroundView = RadarBackgroundView(configure: configure)
        self.addSubview(radarBackgroundView)
        self.backgroundView = radarBackgroundView
        self.notificationToken = NotificationCenter.default.addObserver(forName: .didComputeLabelLocationForRadar, object: backgroundView, queue: .main){
            [weak self] notification in
            guard let strongSelf = self else {
                return
            }
            guard let info = notification.userInfo, let lineEndPoint = info[radarBackgroundView.notificationInfoKey] as? [CGPoint] else {
                return
            }
            strongSelf.updateCoupleTitleDynamicConstraints(for: lineEndPoint)
        }
    }
    
    private func updateRadarBackgroundViewStaticConstraints() {
        guard let background = self.backgroundView else {
            return
        }
        background.snp.remakeConstraints{
            make in
            make.center.equalToSuperview()
            make.width.equalTo(0)
            make.height.equalTo(0)
        }
    }
    
    private func updateRadarBackgroundViewDynamicConstraints() {
        guard let background = self.backgroundView else {
            return
        }
        var width: CGFloat
        var height: CGFloat
        if self.configure.isShowCoupleTitles {
            width = self.bounds.width - 2 * coupleTitleWidth - 2 * titleSpace
            height = self.bounds.height - 2 * coupleTitleHeight - 2 * titleSpace
        } else {
            width = self.bounds.width
            height = self.bounds.height
        }
        background.snp.updateConstraints{
            make in
            make.width.equalTo(width)
            make.height.equalTo(height)
        }
    }
    
    private func updateRadarDataViewStaticConstraints() {
        guard let background = self.backgroundView else {
            return
        }
        for dataView in self.radarDataViews {
            dataView.snp.remakeConstraints{
                make in
                make.bottom.top.trailing.leading.equalTo(background)
            }
        }
    }
    
    private func updateCoupleTitleDynamicConstraints(for points: [CGPoint]) {
        guard self.configure.isShowCoupleTitles else {
            return
        }
        guard let backgroundView = self.backgroundView else {
            return
        }
        let locationOfPoints = self.configure.locationOfPoints
        guard self.coupleTitles.count >= 3, locationOfPoints.count == points.count, points.count == self.coupleTitles.count else {
            return
        }
        let endPoints = points.map({
            backgroundView.convert($0, to: self)
        })
        let coupleTitles = self.coupleTitles
        for (index, coupleTitleView) in coupleTitles.enumerated() {
            var center = CGPoint.zero
            switch locationOfPoints[index] {
            case .left:
                let centerY = endPoints[index].y
                let centerX = endPoints[index].x - coupleTitleWidth / 2 - titleSpace
                center = CGPoint(x: centerX, y: centerY)
            case .right:
                let centerY = endPoints[index].y
                let centerX = endPoints[index].x + coupleTitleWidth / 2 + titleSpace
                center = CGPoint(x: centerX, y: centerY)
            case .top:
                let centerY = endPoints[index].y - coupleTitleHeight / 2 - titleSpace
                let centerX = endPoints[index].x
                center = CGPoint(x: centerX, y: centerY)
            case .bottom:
                let centerY = endPoints[index].y + coupleTitleHeight / 2 + titleSpace
                let centerX = endPoints[index].x
                center = CGPoint(x: centerX, y: centerY)
            }

            coupleTitleView.snp.updateConstraints{
                make in
                make.height.equalTo(coupleTitleHeight)
                make.width.equalTo(coupleTitleWidth)
                make.center.equalTo(center)
            }
            coupleTitleView.setNeedsLayout()
            coupleTitleView.layoutIfNeeded()
        }
    }
    
    override func startAnimation(animation: LiteChartAnimationInterface) {
        guard self.animationStatus == .ready || self.animationStatus == .cancel || self.animationStatus == .finish else {
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
        
        let strideLegnth = 1 / CGFloat(self.coupleTitles.count)
        let progress: [CGFloat] = Array(stride(from: 0, through: 1 - strideLegnth, by: strideLegnth))
        let time = animation.animationTimingFunction.getTimeForSortedProgress(for: progress).map({
            Double($0) * duration
        })
        print(time)
        for (index, label) in self.coupleTitles.enumerated() {
            springAnimation.beginTime = current + animation.delay + time[index]
            label.layer.syncTimeSystemToFather()
            label.layer.add(springAnimation, forKey: springExpandAnimationKey)
            
        }
        for radar in self.radarDataViews {
            radar.startAnimation(animation: animation)
        }
        self.insideAnimationStatus = .running
    }
    
    override func stopAnimation() {
        guard self.animationStatus == .running || self.animationStatus == .pause else {
            return
        }
        self.stopInsideAnimation()
        for radar in self.radarDataViews {
            radar.stopAnimation()
        }
    }
    
    private func stopInsideAnimation() {
        guard self.insideAnimationStatus == .running || self.insideAnimationStatus == .pause else {
            return
        }
        for label in self.coupleTitles {
            label.layer.removeAnimation(forKey: springExpandAnimationKey)
            label.layer.syncTimeSystemToFather()
        }
        self.insideAnimationStatus = .cancel
    }
    
    override func pauseAnimation() {
        guard self.animationStatus == .running else {
            return
        }
        pauseInsideAnimation()
        for radar in self.radarDataViews {
            radar.pauseAnimation()
        }
    }
    
    private func pauseInsideAnimation() {
        guard self.insideAnimationStatus == .running else {
            return
        }
        let current = CACurrentMediaTime()
        for label in self.coupleTitles {
            let pauseTime = (current - label.layer.beginTime) * Double(label.layer.speed) + label.layer.timeOffset
            label.layer.speed = 0
            label.layer.timeOffset = pauseTime
        }
        self.insideAnimationStatus = .pause
    }
    
    override func continueAnimation() {
        guard self.animationStatus == .pause else {
            return
        }
        continueInsideAnimation()
        for radar in self.radarDataViews {
            radar.continueAnimation()
        }
    }
    
    private func continueInsideAnimation() {
        guard self.insideAnimationStatus == .pause else {
            return
        }
        let current = CACurrentMediaTime()
        for label in self.coupleTitles {
            label.layer.beginTime = current
            label.layer.speed = 1
        }
        self.insideAnimationStatus = .running
    }
    
    override var animationStatus: LiteChartAnimationStatus {
        self.radarDataViews.reduce(self.insideAnimationStatus, {
            $0.compactAnimatoinStatus(another: $1.animationStatus)
        })
    }
}


extension RadarChartView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.completeAnimationCount += 1
        if self.completeAnimationCount ==  self.coupleTitles.count {
            if self.insideAnimationStatus != .cancel {
                self.insideAnimationStatus = .finish
            }
            self.completeAnimationCount = 0
        }
    }
}
