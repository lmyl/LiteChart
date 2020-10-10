//
//  LiteChartRadarChartInterface.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/10/10.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation

struct LiteChartRadarChartInterface: LiteChartInterface {
    var inputDatas: [(LiteChartDarkLightColor, [Double])]
    
    var isShowingCoupleTitles = false
    
    var coupleTitles: [String] = []
    
    var coupleTitlesColor: LiteChartDarkLightColor = .init(lightColor: .black, darkColor: .white)
    
    var inputLegendTitles: [String] = []
    
    var radarLineColor: LiteChartDarkLightColor = .init(lightColor: .Gray)
    
    var radarLightColor: LiteChartDarkLightColor = .init(lightColor: .white)
    
    var radarUnlightColor: LiteChartDarkLightColor = .init(lightColor: .lightGray)
    
    var radarCount = 1
    
    init(inputDatas: [(LiteChartDarkLightColor, [Double])]) {
        self.inputDatas = inputDatas
    }
    
    var parametersProcesser: LiteChartParametersProcesser {
        RadarChartParameters(inputDatas: inputDatas, isShowingCoupleTitles: isShowingCoupleTitles, coupleTitles: coupleTitles, coupleTitlesColor: coupleTitlesColor, inputLegendTitles: inputLegendTitles, radarLineColor: radarLineColor, radarLightColor: radarLightColor, radarUnlightColor: radarUnlightColor, radarCount: radarCount)
    }
    
}
