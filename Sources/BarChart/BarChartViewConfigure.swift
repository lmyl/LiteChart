//
//  BarChartViewConfigure.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/11.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation
import CoreGraphics

struct BarChartViewConfigure {
    let textColor: LiteChartDarkLightColor
    
    let coupleTitle: [String]
    
    let valueTitle: [String]
    
    let inputDatas: [(LiteChartDarkLightColor ,[(String?, CGFloat)])]
    
    let direction: BarChartDirection
    
    let borderColor: LiteChartDarkLightColor
    
    let borderStyle: BarChartViewBorderStyle
    
    let xDividingPoints: [AxisDividingLineConfigure]
    
    let yDividingPoints: [AxisDividingLineConfigure]
    
}

extension BarChartViewConfigure {
    init() {
        self.textColor = .init(lightUIColor: .black, darkUIColor: .white)
        self.coupleTitle = []
        self.valueTitle = []
        self.inputDatas = []
        self.direction = .bottomToTop
        self.borderColor = .init(lightUIColor: .black, darkUIColor: .white)
        self.xDividingPoints = []
        self.yDividingPoints = []
        self.borderStyle = .halfSurrounded
    }
}

