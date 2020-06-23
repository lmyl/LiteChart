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
    
    init(backgroundConfigure: RadarBackgroundViewConfigure) {
        self.backgroundConfigure = backgroundConfigure
    }
    init() {
        self.backgroundConfigure = RadarBackgroundViewConfigure()
    }
}
