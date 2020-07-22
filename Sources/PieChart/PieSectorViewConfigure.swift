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
    
    var lineColor: LiteChartDarkLightColor
    
    let isShowLine: Bool
    
    var averageAngle: CGFloat {
        self.computeAverageAngle(start: startAngle, end: endAngle)
    }
    
    var isLeftSector: Bool {
         self.averageAngle >= 90 && self.averageAngle < 270
    }
    
    
    init(startAngle: CGFloat, endAngle: CGFloat, backgroundColor: LiteChartDarkLightColor, isShowLine: Bool, lineColor: LiteChartDarkLightColor = .init(lightColor: .black, darkColor: .white)) {
        self.startAngle = startAngle
        self.endAngle = endAngle
        self.backgroundColor = backgroundColor
        self.lineColor = lineColor
        self.isShowLine = isShowLine
    }
    
    private init() {
        self.startAngle = 0
        self.endAngle = 360
        self.backgroundColor = .init(lightUIColor: .black, darkUIColor: .white)
        self.lineColor = .init(lightColor: .black, darkColor: .white)
        self.isShowLine = false
    }
    
    private func computeAverageAngle(start: CGFloat, end: CGFloat) -> CGFloat {
        (start + end) / 2
    }
}

extension PieSectorViewConfigure {
    static let emptyConfigure = PieSectorViewConfigure()
}
