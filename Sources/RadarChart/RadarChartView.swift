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
        super.layoutSubviews()
        
        updateRadarBackgroundViewDynamicConstraints()
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
        let configures = self.configure.radarDataViewsConfigure
        for dataViewConfigure in configures {
            let view = RadarDataView(configure: dataViewConfigure)
            self.addSubview(view)
            self.radarDataViews.append(view)
        }
    }
    
    private func insertRadarBackgroundView(){
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
        background.snp.updateConstraints{
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
            dataView.snp.updateConstraints{
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
            coupleTitleView.layoutIfNeeded()
        }
    }
}
