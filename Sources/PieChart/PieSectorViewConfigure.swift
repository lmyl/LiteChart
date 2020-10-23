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

    init(startAngle: CGFloat, endAngle: CGFloat, backgroundColor: LiteChartDarkLightColor) {
        self.startAngle = startAngle
        self.endAngle = endAngle
        self.backgroundColor = backgroundColor
    }
    
    private init() {
        self.startAngle = 0
        self.endAngle = 360
        self.backgroundColor = .init(lightUIColor: .black, darkUIColor: .white)
    }
    
    var averageAngle: CGFloat {
        self.computeAverageAngle(start: startAngle, end: endAngle)
    }
    
    var isLeftSector: Bool {
         self.averageAngle >= 90 && self.averageAngle < 270
    }
    
    private func computeAverageAngle(start: CGFloat, end: CGFloat) -> CGFloat {
        (start + end) / 2
    }
}

extension PieSectorViewConfigure {
    static let emptyConfigure = PieSectorViewConfigure()
}
