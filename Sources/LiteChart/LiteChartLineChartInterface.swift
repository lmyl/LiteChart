//
//  LiteChartLineChartInterface.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/10/9.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation

public struct LiteChartLineChartInterface: LiteChartInterface {
    public var borderStyle: LiteChartViewBorderStyle = .halfSurrounded
    
    public var underlayerColor: LiteChartDarkLightColor = .init(lightColor: .black, darkColor: .white)
    
    public var displayDataMode: ChartValueDisplayMode = .original
    
    public var inputLegendTitles: [String] = []
    
    public var inputDatas: [(LiteChartDarkLightColor, LineStyle, Legend , [Double])]
    
    public var coupleTitles: [String]
            
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
    
    public init(inputDatas: [(LiteChartDarkLightColor, LineStyle, Legend , [Double])], coupleTitle: [String]) {
        self.inputDatas = inputDatas
        self.coupleTitles = coupleTitle
    }
    
    public var parametersProcesser: LiteChartParametersProcesser {
        LineChartParameters(borderStyle: borderStyle, borderColor: underlayerColor, displayDataMode: displayDataMode, inputLegendTitles: inputLegendTitles, inputDatas: inputDatas, valueTextColor: underlayerColor, coupleTitles: coupleTitles, coupleTextColor: underlayerColor, isShowValueDividingLine: isShowValueDividingLine, dividingValueLineStyle: dividingValueLineStyle, dividingValueLineColor: underlayerColor, isShowCoupleDividingLine: isShowCoupleDividingLine, dividingCoupleLineStyle: dividingCoupleLineStyle, dividingCoupleLineColor: underlayerColor, isShowValueUnitString: isShowValueUnitString, valueUnitString: valueUnitString, valueUnitTextColor: unitTextColor, isShowCoupleUnitString: isShowCoupleUnitString, coupleUnitString: coupleUnitString, coupleUnitTextColor: unitTextColor, axisColor: axisColor, isShowAxis: isShowAxis)
    }
}
