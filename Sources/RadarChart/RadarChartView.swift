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
    private var configure: RadarChartViewConfigure
    
    private var backgroundView: RadarBackgroundView?
    
    init(configure: RadarChartViewConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
        insertRadarBackgroundView()
        insertRadarDateView()
        
        updateRadarBackgroundViewStaticConstraints()
    }
    
    required init?(coder: NSCoder) {
        self.configure = RadarChartViewConfigure.emptyConfigure
        super.init(coder: coder)
        insertRadarBackgroundView()
        insertRadarDateView()
        
        updateRadarBackgroundViewStaticConstraints()
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
    
    private func updateRadarBackgroundViewStaticConstraints() {
        guard let background = self.backgroundView else {
            return
        }
        background.snp.updateConstraints{
            make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
