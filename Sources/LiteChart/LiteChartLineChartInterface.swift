//
//  LiteChartLineChartInterface.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/10/9.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation

struct LiteChartLineChartInterface: LiteChartInterface {
    var borderStyle: LiteChartViewBorderStyle = .halfSurrounded
    
    var underlayerColor: LiteChartDarkLightColor = .init(lightColor: .black, darkColor: .white)
    
    var displayDataMode: ChartValueDisplayMode = .original
    
    var inputLegendTitles: [String] = []
    
    var inputDatas: [(LiteChartDarkLightColor, LineStyle, Legend , [Double])]
    
    var coupleTitles: [String]
            
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
    
    init(inputDatas: [(LiteChartDarkLightColor, LineStyle, Legend , [Double])], coupleTitle: [String]) {
        self.inputDatas = inputDatas
        self.coupleTitles = coupleTitle
    }
    
    var parametersProcesser: LiteChartParametersProcesser {
        LineChartParameters(borderStyle: borderStyle, borderColor: underlayerColor, displayDataMode: displayDataMode, inputLegendTitles: inputLegendTitles, inputDatas: inputDatas, valueTextColor: underlayerColor, coupleTitles: coupleTitles, coupleTextColor: underlayerColor, isShowValueDividingLine: isShowValueDividingLine, dividingValueLineStyle: dividingValueLineStyle, dividingValueLineColor: underlayerColor, isShowCoupleDividingLine: isShowCoupleDividingLine, dividingCoupleLineStyle: dividingCoupleLineStyle, dividingCoupleLineColor: underlayerColor, isShowValueUnitString: isShowValueUnitString, valueUnitString: valueUnitString, valueUnitTextColor: unitTextColor, isShowCoupleUnitString: isShowCoupleUnitString, coupleUnitString: coupleUnitString, coupleUnitTextColor: unitTextColor, axisColor: axisColor, isShowAxis: isShowAxis)
    }
}
