//
//  RadarBackgroundViewConfigure.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/22.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation

struct RadarBackgroundViewConfigure {
    let coupleTitlesConfigure: [DisplayLabelConfigure]
    let radarLineColor: LiteChartDarkLightColor
    let radarLightColor: LiteChartDarkLightColor
    let radarUnlightColor: LiteChartDarkLightColor
    let radarCount: Int
    let pointCount: Int
}

extension RadarBackgroundViewConfigure {
    init() {
        self.coupleTitlesConfigure = []
        self.radarLineColor = .init(lightUIColor: .gray, darkUIColor: .white)
        self.radarLightColor = .init(lightUIColor: .white, darkUIColor: .black)
        self.radarUnlightColor = .init(lightUIColor: .lightGray, darkUIColor: .white)
        self.radarCount = 1
        self.pointCount = 3 
    }
}
