//
//  LiteChartBubbleChartInterface.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/10/10.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation
import CoreGraphics

struct LiteChartBubbleChartInterface: LiteChartInterface {
    var borderStyle: LiteChartViewBorderStyle = .halfSurrounded
    
    var underlayerColor: LiteChartDarkLightColor = .init(lightColor: .black, darkColor: .white)
    
    var inputLegendTitles: [String] = []
    
    var inputDatas: [(LiteChartDarkLightColor, [(scale: CGFloat, location: CGPoint)])]
    
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
    
    init(inputDatas: [(LiteChartDarkLightColor, [(scale: CGFloat, location: CGPoint)])]) {
        self.inputDatas = inputDatas
    }
    
    var parametersProcesser: LiteChartParametersProcesser {
        BubbleChartParameters(borderStyle: borderStyle, borderColor: underlayerColor, inputLegendTitles: inputLegendTitles, inputDatas: inputDatas, valueTextColor: underlayerColor, coupleTextColor: underlayerColor, isShowValueDividingLine: isShowValueDividingLine, dividingValueLineStyle: dividingValueLineStyle, dividingValueLineColor: underlayerColor, isShowCoupleDividingLine: isShowCoupleDividingLine, dividingCoupleLineStyle: dividingCoupleLineStyle, dividingCoupleLineColor: underlayerColor, isShowValueUnitString: isShowValueUnitString, valueUnitString: valueUnitString, valueUnitTextColor: unitTextColor, isShowCoupleUnitString: isShowCoupleUnitString, coupleUnitString: coupleUnitString, coupleUnitTextColor: unitTextColor, axisColor: axisColor, isShowAxis: isShowAxis)
    }
    
}
