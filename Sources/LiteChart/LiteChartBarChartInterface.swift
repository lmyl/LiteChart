//
//  LiteChartBarChartInterface.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/10/9.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation

public struct LiteChartBarChartInterface: LiteChartInterface {
    public var inputDatas: [(LiteChartDarkLightColor, [Double])]
    
    public var coupleTitle: [String]
    
    public var borderStyle: LiteChartViewBorderStyle = .halfSurrounded
    
    public var underlayerColor: LiteChartDarkLightColor = .init(lightColor: .black, darkColor: .white)
    
    public var direction: BarChartDirection = .bottomToTop
    
    public var displayDataMode: ChartValueDisplayMode = .original
    
    public var inputLegendTitles: [String] = []
    
    public var isShowValueDividingLine = true
                    
    public var dividingValueLineStyle: AxisViewLineStyle = .dotted
        
    public var isShowCoupleDividingLine = true
    
    public var dividingCoupleLineStyle: AxisViewLineStyle = .dotted
    
    public var isShowValueUnitString = false
    
    public var isShowCoupleUnitString = false
    
    public var unitTextColor: LiteChartDarkLightColor = .init(lightColor: .black, darkColor: .white)
        
    public var valueUnitString = ""
    
    public var coupleUnitString = ""
    
    public init(inputDatas: [(LiteChartDarkLightColor, [Double])], coupleTitle: [String]) {
        self.inputDatas = inputDatas
        self.coupleTitle = coupleTitle
    }
    
    public var parametersProcesser: LiteChartParametersProcesser {
        BarChartParameter(borderStyle: borderStyle, borderColor: underlayerColor, direction: direction, displayDataMode: displayDataMode, inputLegendTitles: inputLegendTitles, inputDatas: inputDatas, valueTextColor: underlayerColor, coupleTitle: coupleTitle, coupleTextColor: underlayerColor, isShowValueDividingLine: isShowValueDividingLine, dividingValueLineStyle: dividingValueLineStyle, dividingValueLineColor: underlayerColor, isShowCoupleDividingLine: isShowCoupleDividingLine, dividingCoupleLineStyle: dividingCoupleLineStyle, dividingCoupleLineColor: underlayerColor, isShowValueUnitString: isShowValueUnitString, isShowCoupleUnitString: isShowCoupleUnitString, valueUnitString: valueUnitString, coupleUnitString: coupleUnitString, valueUnitTextColor: unitTextColor, coupleUnitTextColor: unitTextColor)
    }
}
