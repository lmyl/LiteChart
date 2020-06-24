//
//  PlotChartViewConfigure.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/20.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation
import CoreGraphics

struct PlotChartViewConfigure {
    let textColor: LiteChartDarkLightColor
    
    let coupleTitle: [String]
    
    let valueTitle: [String]
    
    let inputDatas: [(LiteChartDarkLightColor, Legend ,[(scale: CGFloat, opacity: CGFloat, CGPoint)])]
        
    let borderColor: LiteChartDarkLightColor
    
    let borderStyle: BarChartViewBorderStyle
    
    let axisOriginal: CGPoint
    
    let axisColor: LiteChartDarkLightColor
    
    let xDividingPoints: [AxisDividingLineConfigure]
    
    let yDividingPoints: [AxisDividingLineConfigure]
    
    let valueUnitString: String?
    
    let coupleUnitString: String?
}

extension PlotChartViewConfigure {
    init() {
        self.textColor = .init(lightUIColor: .black, darkUIColor: .white)
        self.coupleTitle = []
        self.valueTitle = []
        self.inputDatas = []
        self.borderColor = .init(lightUIColor: .black, darkUIColor: .white)
        self.xDividingPoints = []
        self.yDividingPoints = []
        self.borderStyle = .halfSurrounded
        self.valueUnitString = nil
        self.coupleUnitString = nil
        self.axisOriginal = .zero
        self.axisColor = .init(lightUIColor: .black, darkUIColor: .white)
    }
}