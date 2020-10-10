//
//  RadarBackgroundViewConfigure.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/22.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation

struct RadarBackgroundViewConfigure {
    let radarLineColor: LiteChartDarkLightColor
    let radarLightColor: LiteChartDarkLightColor
    let radarUnlightColor: LiteChartDarkLightColor
    let radarLayerCount: Int
    let angleOfPoints: [Double]
}

extension RadarBackgroundViewConfigure {
    private init() {
        self.radarLineColor = .init(lightUIColor: .gray, darkUIColor: .white)
        self.radarLightColor = .init(lightUIColor: .white, darkUIColor: .black)
        self.radarUnlightColor = .init(lightUIColor: .lightGray, darkUIColor: .white)
        self.radarLayerCount = 1
        self.angleOfPoints = [-90, 30, 150]
    }
    
    static let emptyConfigure = RadarBackgroundViewConfigure()
    
    var locationOfPoints: [RadarChartLabelLocation] {
        self.angleOfPoints.map({
            if $0 == 90 {
                return .bottom
            } else if $0 == -90 {
                return .top
            } else if $0 > 90 {
                return .left
            } else {
                return .right
            }
        })
    }
}
