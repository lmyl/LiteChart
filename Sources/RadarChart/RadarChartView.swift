//
//  RadarChartView.swift
//  LiteChart
//
//  Created by huangxiaohui on 2020/6/23.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit
import SnapKit

class RadarChartView: UIView {
    var configure: RadarChartViewConfigure
    
    private var backgroundView: RadarBackgroundView?
    
    init(configure: RadarChartViewConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
        insertRadarBackgroundView()
        insertRadarDateView()
    }
    
    required init?(coder: NSCoder) {
        self.configure = RadarChartViewConfigure()
        super.init(coder: coder)
        insertRadarBackgroundView()
        insertRadarDateView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateRadarBackgroundViewConstraints()
    }
    
    private func insertRadarDateView() {
        guard let background = self.backgroundView else {
            return
        }
        background.insertRadarDataViews(for: self.configure.radarDataViewsConfigure)
    }
    
    private func insertRadarBackgroundView(){
        let configure = self.configure.backgroundConfigure
        let radarBackgroundView = RadarBackgroundView(configure: configure)
        self.addSubview(radarBackgroundView)
        self.backgroundView = radarBackgroundView
    }
    
    private func updateRadarBackgroundViewConstraints() {
        let width = self.bounds.width
        let height = self.bounds.height
        guard let background = self.backgroundView else {
            return
        }
        background.snp.updateConstraints{
            make in
            make.center.equalToSuperview()
            make.width.equalTo(width)
            make.height.equalTo(height)
        }
    }
}
