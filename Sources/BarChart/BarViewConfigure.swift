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
    
    let label: DisplayLabelConfigure
    
    let isShowLabel: Bool
    
    let direction: BarChartDirection
    
    init(length: CGFloat, barColor: LiteChartDarkLightColor, isShowLabel: Bool, label: DisplayLabelConfigure = .emptyConfigure, direction: BarChartDirection = .bottomToTop) {
        self.length = length
        self.barColor = barColor
        self.label = label
        self.direction = direction
        self.isShowLabel = isShowLabel
    }
    
    private init() {
        self.length = 0
        self.barColor = .init(lightUIColor: .black, darkUIColor: .white)
        self.label = .emptyConfigure
        self.isShowLabel = false
        self.direction = .bottomToTop
    }
}

extension BarViewConfigure {
    static let emptyConfigure = BarViewConfigure()
}
