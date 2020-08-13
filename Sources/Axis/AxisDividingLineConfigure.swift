//
//  AxisDividingLineConfigure.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/10.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation
import CoreGraphics

struct AxisDividingLineConfigure {
    let dividingLineStyle: AxisViewLineStyle
    
    let dividingLineColor: LiteChartDarkLightColor
    
    let location: CGFloat
}

extension AxisDividingLineConfigure {
    private init() {
        self.dividingLineColor = .init(lightUIColor: .black, darkUIColor: .white)
        self.dividingLineStyle = .dotted
        self.location = 0
    }
    
    static let emptyConfigure = AxisDividingLineConfigure()
}
