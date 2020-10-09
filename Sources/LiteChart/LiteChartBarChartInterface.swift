//
//  LiteChartBarChartInterface.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/10/9.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation

struct LiteChartBarChartInterface: LiteChartInterface {
    var inputDatas: [(LiteChartDarkLightColor, [Double])]
    
    var coupleTitle: [String]
    
    var borderStyle: LiteChartViewBorderStyle = .halfSurrounded
    
    var underlayerColor: LiteChartDarkLightColor = .init(lightColor: .black, darkColor: .white)
    
    var direction: BarChartDirection = .bottomToTop
    
    var displayDataMode: ChartValueDisplayMode = .original
    
    var inputLegendTitles: [String] = []
    
    var isShowValueDividingLine = true
                    
    var dividingValueLineStyle: AxisViewLineStyle = .dotted
        
    var isShowCoupleDividingLine = true
    
    var dividingCoupleLineStyle: AxisViewLineStyle = .dotted
    
    var isShowValueUnitString = false
    
    var isShowCoupleUnitString = false
    
    var unitTextColor: LiteChartDarkLightColor = .init(lightColor: .black, darkColor: .white)
        
    var valueUnitString = ""
    
    var coupleUnitString = ""
    
    init(inputDatas: [(LiteChartDarkLightColor, [Double])], coupleTitle: [String]) {
        self.inputDatas = inputDatas
        self.coupleTitle = coupleTitle
    }
    
    var parametersProcesser: LiteChartParametersProcesser {
        BarChartParameter(borderStyle: borderStyle, borderColor: underlayerColor, direction: direction, displayDataMode: displayDataMode, inputLegendTitles: inputLegendTitles, inputDatas: inputDatas, valueTextColor: underlayerColor, coupleTitle: coupleTitle, coupleTextColor: underlayerColor, isShowValueDividingLine: isShowValueDividingLine, dividingValueLineStyle: dividingValueLineStyle, dividingValueLineColor: underlayerColor, isShowCoupleDividingLine: isShowCoupleDividingLine, dividingCoupleLineStyle: dividingCoupleLineStyle, dividingCoupleLineColor: underlayerColor, isShowValueUnitString: isShowValueUnitString, isShowCoupleUnitString: isShowCoupleUnitString, valueUnitString: valueUnitString, coupleUnitString: coupleUnitString, valueUnitTextColor: unitTextColor, coupleUnitTextColor: unitTextColor)
    }
}
