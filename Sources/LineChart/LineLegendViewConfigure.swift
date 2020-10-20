//
//  LineLegendViewConfigure.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/10/20.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation
import CoreGraphics

struct LineLegendViewConfigure {
    let points: [[CGPoint]]
    let legendConfigure: [LegendConfigure]
}

extension LineLegendViewConfigure {
    private init() {
        self.points = []
        self.legendConfigure = []
    }
    
    static let emptyConfigure = LineLegendViewConfigure()
}
