//
//  BarViewConfigure.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/11.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation
import CoreGraphics

struct BarViewConfigure {
    let length: CGFloat
    
    let barColor: LiteChartDarkLightColor
    
    let label: DisplayLabelConfigure?
    
    let direction: BarChartDirection
    
    init(length: CGFloat = 0, barColor: LiteChartDarkLightColor = .init(lightUIColor: .black, darkUIColor: .white), label: DisplayLabelConfigure? = nil, direction: BarChartDirection = .bottomToTop) {
        self.length = length
        self.barColor = barColor
        self.label = label
        self.direction = direction
    }
}
