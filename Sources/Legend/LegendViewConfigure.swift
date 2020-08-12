//
//  LegendViewConfigure.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/6.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation

struct LegendViewConfigure {
    
    let legendConfigure: LegendConfigure
    let contentConfigure: DisplayLabelConfigure
    
    init(legendConfigure: LegendConfigure, contentConfigure: DisplayLabelConfigure) {
        self.legendConfigure = legendConfigure
        self.contentConfigure = contentConfigure
    }
    
    private init() {
        self.legendConfigure = LegendConfigure.emptyConfigure
        self.contentConfigure = DisplayLabelConfigure.emptyConfigure
    }
}

extension LegendViewConfigure {
    static let emptyConfigure = LegendViewConfigure()
}
