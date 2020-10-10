//
//  RadarDataViewConfigure.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/22.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation
import CoreGraphics

struct RadarDataViewConfigure {
    let points: [CGFloat]
    let angleOfPoints: [Double]
    let color: LiteChartDarkLightColor
}

extension RadarDataViewConfigure {
    private init() {
        self.points = [0, 0, 0]
        self.angleOfPoints = [-90, 30, 150]
        self.color = .init(lightUIColor: .black, darkUIColor: .white)
    }
    
    static let emptyConfigure = RadarDataViewConfigure()
}
