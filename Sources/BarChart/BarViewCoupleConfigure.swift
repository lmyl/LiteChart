//
//  BarViewsConfigure.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/11.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation

struct BarViewCoupleConfigure {
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

extension BarViewCoupleConfigure {
    static let emptyConfigure = BarViewCoupleConfigure()
}
