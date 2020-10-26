//
//  LiteChartScatterChartInterface.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/10/10.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation
import CoreGraphics

public struct LiteChartScatterChartInterface: LiteChartInterface {
    public var borderStyle: LiteChartViewBorderStyle = .halfSurrounded
    
    public var underlayerColor: LiteChartDarkLightColor = .init(lightColor: .black, darkColor: .white)
    
    public var inputLegendTitles: [String] = []
        
    public var inputDatas: [(LiteChartDarkLightColor, Legend , [CGPoint])]
    
    public var isShowValueDividingLine = false
    
    public var dividingValueLineStyle: AxisViewLineStyle = .dotted
    
    public var isShowCoupleDividingLine = false
    
    public var dividingCoupleLineStyle: AxisViewLineStyle = .dotted
        
    public var isShowValueUnitString = false
    
    public var isShowCoupleUnitString = false
    
    public var valueUnitString = ""
    
    public var coupleUnitString = ""
    
    public var unitTextColor: LiteChartDarkLightColor = .init(lightColor: .black, darkColor: .white)
        
    public var axisColor: LiteChartDarkLightColor = .init(lightColor: .black, darkColor: .white)
    
    public var isShowAxis = false
    
    public init(inputDatas: [(LiteChartDarkLightColor, Legend , [CGPoint])]) {
        self.inputDatas = inputDatas
    }
    
    public var parametersProcesser: LiteChartParametersProcesser {
        ScatterPlotChartParameters(borderStyle: borderStyle, borderColor: underlayerColor, inputLegendTitles: inputLegendTitles, inputDatas: inputDatas, valueTextColor: underlayerColor, coupleTextColor: underlayerColor, isShowValueDividingLine: isShowValueDividingLine, dividingValueLineStyle: dividingValueLineStyle, dividingValueLineColor: underlayerColor, isShowCoupleDividingLine: isShowCoupleDividingLine, dividingCoupleLineStyle: dividingCoupleLineStyle, dividingCoupleLineColor: underlayerColor, isShowValueUnitString: isShowValueUnitString, valueUnitString: valueUnitString, isShowCoupleUnitString: isShowCoupleUnitString, coupleUnitString: coupleUnitString, valueUnitTextColor: unitTextColor, coupleUnitTextColor: unitTextColor, axisColor: axisColor, isShowAxis: isShowAxis)
    }
}
