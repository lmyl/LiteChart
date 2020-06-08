//
//  PieSectorViewConfigure.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/8.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation
import CoreGraphics

struct PieSectorViewConfigure {
    let startAngle: CGFloat
    let endAngle: CGFloat
    
    let backgroundColor: LiteChartDarkLightColor
    
    let lineColor: LiteChartDarkLightColor?
    
    var averageAngle: CGFloat {
        self.computeAverageAngle(start: startAngle, end: endAngle)
    }
    
    var isLeftSector: Bool {
         self.averageAngle >= 90 && self.averageAngle < 270
    }
    
    
    init(startAngle: CGFloat, endAngle: CGFloat, backgroundColor: LiteChartDarkLightColor, lineColor: LiteChartDarkLightColor) {
        self.startAngle = startAngle
        self.endAngle = endAngle
        self.backgroundColor = backgroundColor
        self.lineColor = lineColor
    }
    
    init(startAngle: CGFloat, endAngle: CGFloat, backgroundColor: LiteChartDarkLightColor) {
        self.startAngle = startAngle
        self.endAngle = endAngle
        self.backgroundColor = backgroundColor
        self.lineColor = nil
    }
    
    init() {
        self.startAngle = 0
        self.endAngle = 360
        self.backgroundColor = .init(lightColor: .yellow)
        self.lineColor = nil
    }
    
    private func computeAverageAngle(start: CGFloat, end: CGFloat) -> CGFloat {
        (start + end) / 2
    }
}
