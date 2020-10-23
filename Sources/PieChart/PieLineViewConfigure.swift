//
//  PieLineViewConfigure.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/10/23.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation
import CoreGraphics

struct PieLineViewConfigure {
    
    let pieViewConfigure: PieViewConfigure
    let lineColors: [LiteChartDarkLightColor]
    let isShowLine: Bool
    
    var pieNumber: Int {
        self.pieViewConfigure.pieSectorViewConfigures.count
    }
    
}

extension PieLineViewConfigure {
    private init() {
        self.pieViewConfigure = .emptyConfigure
        self.lineColors = []
        self.isShowLine = false
    }
    
    static let emptyCongfigure = PieLineViewConfigure()
}
