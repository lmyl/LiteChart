//
//  BarViewsConfigure.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/11.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation
import CoreGraphics

struct BarViewsConfigure {
    let models: [BarViewConfigure]
    let direction: BarChartDirection
    
    init(models: [BarViewConfigure], direction: BarChartDirection = .bottomToTop) {
        self.models = models
        self.direction = direction
    }
    
    private init() {
        self.models = []
        self.direction = .bottomToTop
    }
}

extension BarViewsConfigure {
    static let emptyConfigure = BarViewsConfigure()
}
