//
//  LiteChartRadarChartInterface.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/10/10.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation

/// Parameters interface of Radar Chart
public struct LiteChartRadarChartInterface: LiteChartInterface {
    /// An array of eligible chart data, including every layer color and an array of `Double` to display
    public var inputDatas: [(LiteChartDarkLightColor, [Double])]
    
    /// Whether to display couple titles of Radar Chart
    public var isShowingCoupleTitles = false
    
    /// Set the couple titles of Radar Chart (Display in the corners of the radar chart), the count must be the same as the count of data in each group
    public var coupleTitles: [String] = []
    
    /// Set the color of couple titles, black and white by default
    public var coupleTitlesColor: LiteChartDarkLightColor = .init(lightColor: .black, darkColor: .white)
    
    /// Set the legend titles of Radar Chart, the count must be the same as the inputDatas
    public var inputLegendTitles: [String] = []
    
    /// Set the color of Radar Chart's lines
    public var radarLineColor: LiteChartDarkLightColor = .init(lightColor: .Gray)
    
    /// Set the color of the bright area at the bottom of the radar chart
    public var radarLightColor: LiteChartDarkLightColor = .init(lightColor: .white)
    
    /// Set the color of the dark area at the bottom of the radar chart
    public var radarUnlightColor: LiteChartDarkLightColor = .init(lightColor: .lightGray)
    
    /// The number of layers displayed in the radar chart, 1 by default
    public var radarCount = 1
    
    /// Radar Chart initialization
    /// - Parameter inputDatas: An array of eligible chart data
    public init(inputDatas: [(LiteChartDarkLightColor, [Double])]) {
        self.inputDatas = inputDatas
    }
    
    /// Conform to LiteChartParametersProcesser protocol, pass parameters to the underlying processing, determine their legitimacy and do other calculations.
    public var parametersProcesser: LiteChartParametersProcesser {
        RadarChartParameters(inputDatas: inputDatas, isShowingCoupleTitles: isShowingCoupleTitles, coupleTitles: coupleTitles, coupleTitlesColor: coupleTitlesColor, inputLegendTitles: inputLegendTitles, radarLineColor: radarLineColor, radarLightColor: radarLightColor, radarUnlightColor: radarUnlightColor, radarCount: radarCount)
    }
    
}
