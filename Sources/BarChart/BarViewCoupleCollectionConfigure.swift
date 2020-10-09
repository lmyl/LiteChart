//
//  BarViewCoupleCollectionConfigure.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/9/30.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation

struct BarViewCoupleCollectionConfigure {
    let models: [BarViewCoupleConfigure]
    let direction: BarChartDirection
    
    init(models: [BarViewCoupleConfigure], direction: BarChartDirection = .bottomToTop) {
        self.models = models
        self.direction = direction
    }
    
    private init() {
        self.models = []
        self.direction = .bottomToTop
    }
}

extension BarViewCoupleCollectionConfigure {
    static let emptyConfigure = BarViewCoupleCollectionConfigure()
}

