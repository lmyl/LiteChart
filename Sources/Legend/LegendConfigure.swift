//
//  LegendConfigure.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/6.
//  Copyright © 2020 刘洋. All rights reserved.
//

import CoreGraphics

struct LegendConfigure {
    
    let color: LiteChartDarkLightColor
    
    init(color: LiteChartDarkLightColor) {
        self.color = color
    }
    
    init() {
        self.color = .init(lightColor: .yellow)
    }
}
