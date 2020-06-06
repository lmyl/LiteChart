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
    let backgroundColor: LiteChartDarkLightColor
    
    init(color: LiteChartDarkLightColor, backgroundColor: LiteChartDarkLightColor) {
        self.color = color
        self.backgroundColor = backgroundColor
    }
    
    init() {
        self.color = .init(lightColor: .yellow)
        self.backgroundColor = .init(lightColor: .white)
    }
}
