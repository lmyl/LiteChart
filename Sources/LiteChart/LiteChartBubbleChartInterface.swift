//
//  LiteChartBubbleChartInterface.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/10/10.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation
import CoreGraphics

public struct LiteChartBubbleChartInterface: LiteChartInterface {
    public var borderStyle: LiteChartViewBorderStyle = .halfSurrounded
    
    public var underlayerColor: LiteChartDarkLightColor = .init(lightColor: .black, darkColor: .white)
    
    public var inputLegendTitles: [String] = []
    
    public var inputDatas: [(LiteChartDarkLightColor, [(scale: CGFloat, location: CGPoint)])]
    
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
    
    public init(inputDatas: [(LiteChartDarkLightColor, [(scale: CGFloat, location: CGPoint)])]) {
        self.inputDatas = inputDatas
    }
    
    public var parametersProcesser: LiteChartParametersProcesser {
        BubbleChartParameters(borderStyle: borderStyle, borderColor: underlayerColor, inputLegendTitles: inputLegendTitles, inputDatas: inputDatas, valueTextColor: underlayerColor, coupleTextColor: underlayerColor, isShowValueDividingLine: isShowValueDividingLine, dividingValueLineStyle: dividingValueLineStyle, dividingValueLineColor: underlayerColor, isShowCoupleDividingLine: isShowCoupleDividingLine, dividingCoupleLineStyle: dividingCoupleLineStyle, dividingCoupleLineColor: underlayerColor, isShowValueUnitString: isShowValueUnitString, valueUnitString: valueUnitString, valueUnitTextColor: unitTextColor, isShowCoupleUnitString: isShowCoupleUnitString, coupleUnitString: coupleUnitString, coupleUnitTextColor: unitTextColor, axisColor: axisColor, isShowAxis: isShowAxis)
    }
    
}
