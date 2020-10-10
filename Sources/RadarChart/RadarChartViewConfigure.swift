//
//  RadarChartViewConfigure.swift
//  LiteChart
//
//  Created by huangxiaohui on 2020/6/23.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation

struct RadarChartViewConfigure {

    let backgroundConfigure: RadarBackgroundViewConfigure
    let radarDataViewsConfigure: [RadarDataViewConfigure]
    let coupleTitlesConfigure: [DisplayLabelConfigure]
    let isShowCoupleTitles: Bool
    
    var locationOfPoints: [RadarChartLabelLocation] {
        self.backgroundConfigure.locationOfPoints
    }
    
    init(backgroundConfigure: RadarBackgroundViewConfigure, radarDataViewsConfigure: [RadarDataViewConfigure], isShowCoupleTitles: Bool, coupleTitlesConfigure: [DisplayLabelConfigure]) {
        self.backgroundConfigure = backgroundConfigure
        self.radarDataViewsConfigure = radarDataViewsConfigure
        self.isShowCoupleTitles = isShowCoupleTitles
        self.coupleTitlesConfigure = coupleTitlesConfigure
    }
    
    private init() {
        self.backgroundConfigure = RadarBackgroundViewConfigure.emptyConfigure
        self.radarDataViewsConfigure = []
        self.isShowCoupleTitles = false
        self.coupleTitlesConfigure = []
    }
    
    static let emptyConfigure = RadarChartViewConfigure()
}
