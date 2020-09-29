//
//  LineChartViewConfigure.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/17.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation
import CoreGraphics

struct LineChartViewConfigure {
    let textColor: LiteChartDarkLightColor
    
    let coupleTitle: [String]
    
    let valueTitle: [String]
    
    let inputDatas: [(LiteChartDarkLightColor, LineStyle, Legend ,[(String, CGPoint)])]
    
    let isShowLabel: Bool
        
    let borderColor: LiteChartDarkLightColor
    
    let borderStyle: LiteChartViewBorderStyle
    
    let axisOriginal: CGPoint
    
    let axisColor: LiteChartDarkLightColor
    
    let isShowAxis: Bool
    
    let xDividingPoints: [AxisDividingLineConfigure]
    
    let yDividingPoints: [AxisDividingLineConfigure]
    
    let isShowValueUnitString: Bool
    
    let valueUnitString: String
    
    let isShowCoupleUnitString: Bool
    
    let coupleUnitString: String
    
}

extension LineChartViewConfigure {
    private init() {
        self.textColor = .init(lightUIColor: .black, darkUIColor: .white)
        self.coupleTitle = []
        self.valueTitle = []
        self.inputDatas = []
        self.borderColor = .init(lightUIColor: .black, darkUIColor: .white)
        self.xDividingPoints = []
        self.yDividingPoints = []
        self.borderStyle = .halfSurrounded
        self.valueUnitString = ""
        self.coupleUnitString = ""
        self.isShowLabel = false
        self.isShowValueUnitString = false
        self.isShowCoupleUnitString = false
        self.axisOriginal = .zero
        self.axisColor = .init(lightUIColor: .black, darkUIColor: .white)
        self.isShowAxis = false
    }
    
    static let emptyConfigure = LineChartViewConfigure()
}
