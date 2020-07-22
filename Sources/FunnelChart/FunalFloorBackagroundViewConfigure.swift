//
//  FunalFloorBackagroundViewConfigure.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/5.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation
import CoreGraphics

struct FunalFloorBackagroundViewConfigure {
    
    let color: LiteChartDarkLightColor
    let topPercent: CGFloat
    let bottomPercent: CGFloat
    
    init(color: LiteChartDarkLightColor, topPercent: CGFloat, bottomPercent: CGFloat) {
        self.color = color
        self.topPercent = topPercent
        self.bottomPercent = bottomPercent
    }
    
    private init() {
        self.color = .init(lightUIColor: .black, darkUIColor: .white)
        self.topPercent = 1
        self.bottomPercent = 1
    }
}


extension FunalFloorBackagroundViewConfigure {
    static let emptyConfigure = FunalFloorBackagroundViewConfigure()
}
