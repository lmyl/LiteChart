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
    let vertexCount: Int
    
    var angleOfPoints: [Double] {
        var angles = [Double]()
        for index in 0 ..< self.vertexCount {
            let angle = 360 / Double(self.vertexCount) * Double(index) - 90
            angles.append(angle)
        }
        return angles
    }
}

extension RadarBackgroundViewConfigure {
    private init() {
        self.radarLineColor = .init(lightUIColor: .gray, darkUIColor: .white)
        self.radarLightColor = .init(lightUIColor: .white, darkUIColor: .black)
        self.radarUnlightColor = .init(lightUIColor: .lightGray, darkUIColor: .white)
        self.radarLayerCount = 1
        self.vertexCount = 3
    }
    
    static let emptyConfigure = RadarBackgroundViewConfigure()
}
