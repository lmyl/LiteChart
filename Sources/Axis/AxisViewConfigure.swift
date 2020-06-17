//
//  c.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/10.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation
import CoreGraphics

struct AxisViewConfigure {
    
    let verticalDividingPoints : [AxisDividingLineConfigure]
    
    let horizontalDividingPoints: [AxisDividingLineConfigure]
    
    let originPoint: CGPoint
    
    let axisColor: LiteChartDarkLightColor
    
    let borderColor: LiteChartDarkLightColor
    
    let borderStyle: [AxisViewBorderStyle]
    
    let isShowXAxis: Bool
    
    let isShowYAxis: Bool
    
    init(originPoint: CGPoint = CGPoint(x: 0, y: 0), axisColor: LiteChartDarkLightColor = .init(lightUIColor: .black, darkUIColor: .white), verticalDividingPoints : [AxisDividingLineConfigure] = [], horizontalDividingPoints: [AxisDividingLineConfigure] = [], borderStyle: [AxisViewBorderStyle] = [], borderColor: LiteChartDarkLightColor = .init(lightUIColor: .black, darkUIColor: .white), isShowXAxis: Bool = true, isShowYAxis: Bool = true) {
        self.originPoint = originPoint
        self.axisColor = axisColor
        self.verticalDividingPoints = verticalDividingPoints
        self.horizontalDividingPoints = horizontalDividingPoints
        self.borderColor = borderColor
        self.borderStyle = borderStyle
        self.isShowXAxis = isShowXAxis
        self.isShowYAxis = isShowYAxis
    }
}
