//
//  LegendViewsConfigure.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/6.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation

struct LegendViewsConfigure {
    let models: [LegendViewConfigure]
    
    init(models: [LegendViewConfigure]) {
        self.models = models
    }
    
    private init() {
        self.models = []
    }
}

extension LegendViewsConfigure {
    static let emptyConfigure = LegendViewsConfigure()
}
