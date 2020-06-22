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
    let color: LiteChartDarkLightColor
}

extension RadarDataViewConfigure {
    init() {
        self.points = []
        self.color = .init(lightUIColor: .black, darkUIColor: .white)
    }
}
