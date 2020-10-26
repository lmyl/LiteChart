//
//  LiteChartRadarChartInterface.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/10/10.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation

public struct LiteChartRadarChartInterface: LiteChartInterface {
    public var inputDatas: [(LiteChartDarkLightColor, [Double])]
    
    public var isShowingCoupleTitles = false
    
    public var coupleTitles: [String] = []
    
    public var coupleTitlesColor: LiteChartDarkLightColor = .init(lightColor: .black, darkColor: .white)
    
    public var inputLegendTitles: [String] = []
    
    public var radarLineColor: LiteChartDarkLightColor = .init(lightColor: .Gray)
    
    public var radarLightColor: LiteChartDarkLightColor = .init(lightColor: .white)
    
    public var radarUnlightColor: LiteChartDarkLightColor = .init(lightColor: .lightGray)
    
    public var radarCount = 1
    
    public init(inputDatas: [(LiteChartDarkLightColor, [Double])]) {
        self.inputDatas = inputDatas
    }
    
    public var parametersProcesser: LiteChartParametersProcesser {
        RadarChartParameters(inputDatas: inputDatas, isShowingCoupleTitles: isShowingCoupleTitles, coupleTitles: coupleTitles, coupleTitlesColor: coupleTitlesColor, inputLegendTitles: inputLegendTitles, radarLineColor: radarLineColor, radarLightColor: radarLightColor, radarUnlightColor: radarUnlightColor, radarCount: radarCount)
    }
    
}
