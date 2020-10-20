//
//  LineViewsConfigure.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/17.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation

struct LineViewsConfigure {
    let models: [LineViewConfigure]
    let valueModel: LineValueViewConfigure
    let legendModel: LineLegendViewConfigure
    let isShowLabel: Bool
}

extension LineViewsConfigure {
    private init() {
        self.models = []
        self.valueModel = .emptyConfigure
        self.legendModel = .emptyConfigure
        self.isShowLabel = false
    }
    
    static let emptyConfigure = LineViewsConfigure()
}
