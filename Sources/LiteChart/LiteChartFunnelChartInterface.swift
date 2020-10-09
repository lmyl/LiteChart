//
//  LiteChartFunnelChartInterface.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/10/9.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation

struct LiteChartFunnelChartInterface: LiteChartInterface {
    var inputDatas: [(Double, LiteChartDarkLightColor)]
    
    var valueTextColor: LiteChartDarkLightColor = .init(lightColor: .black, darkColor: .white)
    
    var inputLegendTitles: [String] = []
    
    var displayDataMode: ChartValueDisplayMode = .original
    
    init(inputDatas: [(Double, LiteChartDarkLightColor)]) {
        self.inputDatas = inputDatas
    }
    
    var parametersProcesser: LiteChartParametersProcesser {
        FunalChartParameters(inputDatas: inputDatas, inputLegendTitles: inputLegendTitles, displayDataMode: displayDataMode, valueTextColor: valueTextColor)
    }
}
