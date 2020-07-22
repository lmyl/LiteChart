//
//  LegendViewConfigure.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/6.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation

struct LegendViewConfigure {
    
    let legendType: Legend
    let legendConfigure: LegendConfigure
    let contentConfigure: DisplayLabelConfigure
    
    init(legendType: Legend, legendConfigure: LegendConfigure, contentConfigure: DisplayLabelConfigure) {
        self.legendType = legendType
        self.legendConfigure = legendConfigure
        self.contentConfigure = contentConfigure
    }
    
    init() {
        self.legendType = .square
        self.legendConfigure = LegendConfigure()
        self.contentConfigure = DisplayLabelConfigure.emptyConfigure
    }
}
