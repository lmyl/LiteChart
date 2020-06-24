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
    
    init(backgroundConfigure: RadarBackgroundViewConfigure, radarDataViewsConfigure: [RadarDataViewConfigure]) {
        self.backgroundConfigure = backgroundConfigure
        self.radarDataViewsConfigure = radarDataViewsConfigure
    }
    init() {
        self.backgroundConfigure = RadarBackgroundViewConfigure()
        self.radarDataViewsConfigure = []
    }
}
