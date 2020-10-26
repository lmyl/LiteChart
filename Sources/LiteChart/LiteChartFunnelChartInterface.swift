//
//  LiteChartFunnelChartInterface.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/10/9.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation

public struct LiteChartFunnelChartInterface: LiteChartInterface {
    public var inputDatas: [(Double, LiteChartDarkLightColor)]
    
    public var valueTextColor: LiteChartDarkLightColor = .init(lightColor: .black, darkColor: .white)
    
    public var inputLegendTitles: [String] = []
    
    public var displayDataMode: ChartValueDisplayMode = .original
    
    public init(inputDatas: [(Double, LiteChartDarkLightColor)]) {
        self.inputDatas = inputDatas
    }
    
    public var parametersProcesser: LiteChartParametersProcesser {
        FunalChartParameters(inputDatas: inputDatas, inputLegendTitles: inputLegendTitles, displayDataMode: displayDataMode, valueTextColor: valueTextColor)
    }
}
