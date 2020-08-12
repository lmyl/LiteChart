//
//  LegendConfigure.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/6.
//  Copyright © 2020 刘洋. All rights reserved.
//

import CoreGraphics

struct LegendConfigure {
    
    let type: Legend
    let color: LiteChartDarkLightColor
    
    init(type: Legend, color: LiteChartDarkLightColor) {
        self.type = type
        self.color = color
    }
    
    private init() {
        self.type = .square
        self.color = .init(lightUIColor: .yellow, darkUIColor: .blue)
    }
}

extension LegendConfigure {
    static let emptyConfigure = LegendConfigure()
}
