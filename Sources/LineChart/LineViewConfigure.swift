//
//  LineViewConfigure.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/16.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation
import CoreGraphics

struct LineViewConfigure {
    let points: [CGPoint]
    let legendType: Legend
    let legendConfigure: LegendConfigure
    let lineStyle: LineStyle
    let lineColor: LiteChartDarkLightColor
    let labelConfigure: [DisplayLabelConfigure]?
}

extension LineViewConfigure {
    init() {
        self.points = []
        self.legendType = .circle
        self.legendConfigure = .init()
        self.lineColor = .init(lightUIColor: .black, darkUIColor: .white)
        self.lineStyle = .dotted
        self.labelConfigure = nil
    }
}
