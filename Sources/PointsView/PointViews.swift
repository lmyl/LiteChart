//
//  PointViews.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/20.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit
import SnapKit

class PointViews: UIView {
    private let configure: PointViewsConfigure
    
    private var pointsView: [PointsView] = []
    
    init(configure: PointViewsConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
        insertPointsView()
        
        updatePointsViewStaticConstraints()
    }
    
    required init?(coder: NSCoder) {
        self.configure = PointViewsConfigure.emptyConfigure
        super.init(coder: coder)
        insertPointsView()
        
        updatePointsViewStaticConstraints()
    }
    
    private func insertPointsView() {
        for view in self.pointsView {
            view.removeFromSuperview()
        }
        self.pointsView = []
        for configure in self.configure.models {
            let view = PointsView(configure: configure)
            self.addSubview(view)
            self.pointsView.append(view)
        }
    }
    
    private func updatePointsViewStaticConstraints() {
        for view in self.pointsView {
            view.snp.remakeConstraints{
                make in
                make.leading.trailing.top.bottom.equalToSuperview()
            }
        }
    }
}

extension PointViews: LiteChartAnimatable {
    func startAnimation(animation: LiteChartAnimationInterface) {
        guard self.animationStatus == .cancel || self.animationStatus == .ready || self.animationStatus == .finish else {
            return
        }
        for point in self.pointsView {
            point.startAnimation(animation: animation)
        }
    }
    
    func stopAnimation() {
        guard self.animationStatus == .running || self.animationStatus == .pause else {
            return
        }
        for point in self.pointsView {
            point.stopAnimation()
        }
    }
    
    func pauseAnimation() {
        guard self.animationStatus == .running else {
            return
        }
        for point in self.pointsView {
            point.pauseAnimation()
        }
    }
    
    func continueAnimation() {
        guard self.animationStatus == .pause else {
            return
        }
        for point in self.pointsView {
            point.continueAnimation()
        }
    }
    
    var animationStatus: LiteChartAnimationStatus {
        self.pointsView.reduce(LiteChartAnimationStatus.ready, {
            $0.compactAnimatoinStatus(another: $1.animationStatus)
        })
    }
}
