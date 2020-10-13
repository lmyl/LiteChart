//
//  LiteChartScatterChartInterface.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/10/10.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation
import CoreGraphics

struct LiteChartScatterChartInterface: LiteChartInterface {
    var borderStyle: LiteChartViewBorderStyle = .halfSurrounded
    
    var underlayerColor: LiteChartDarkLightColor = .init(lightColor: .black, darkColor: .white)
    
    var inputLegendTitles: [String] = []
        
    var inputDatas: [(LiteChartDarkLightColor, Legend , [CGPoint])]
    
    var isShowValueDividingLine = false
    
    var dividingValueLineStyle: AxisViewLineStyle = .dotted
    
    var isShowCoupleDividingLine = false
    
    var dividingCoupleLineStyle: AxisViewLineStyle = .dotted
        
    var isShowValueUnitString = false
    
    var isShowCoupleUnitString = false
    
    var valueUnitString = ""
    
    var coupleUnitString = ""
    
    var unitTextColor: LiteChartDarkLightColor = .init(lightColor: .black, darkColor: .white)
        
    var axisColor: LiteChartDarkLightColor = .init(lightColor: .black, darkColor: .white)
    
    var isShowAxis = false
    
    init(inputDatas: [(LiteChartDarkLightColor, Legend , [CGPoint])]) {
        self.inputDatas = inputDatas
    }
    
    var parametersProcesser: LiteChartParametersProcesser {
        ScatterPlotChartParameters(borderStyle: borderStyle, borderColor: underlayerColor, inputLegendTitles: inputLegendTitles, inputDatas: inputDatas, valueTextColor: underlayerColor, coupleTextColor: underlayerColor, isShowValueDividingLine: isShowValueDividingLine, dividingValueLineStyle: dividingValueLineStyle, dividingValueLineColor: underlayerColor, isShowCoupleDividingLine: isShowCoupleDividingLine, dividingCoupleLineStyle: dividingCoupleLineStyle, dividingCoupleLineColor: underlayerColor, isShowValueUnitString: isShowValueUnitString, valueUnitString: valueUnitString, isShowCoupleUnitString: isShowCoupleUnitString, coupleUnitString: coupleUnitString, valueUnitTextColor: unitTextColor, coupleUnitTextColor: unitTextColor, axisColor: axisColor, isShowAxis: isShowAxis)
    }
}
