//
//  LiteChartFunnelChartInterface.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/10/9.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation

/// Parameters interface of Funnel Chart
public struct LiteChartFunnelChartInterface: LiteChartInterface {
    /// An array of eligible chart data, including the color of the block and the data corresponding to the block
    public var inputDatas: [(Double, LiteChartDarkLightColor)]
    
    /// Set the color of value text
    public var valueTextColor: LiteChartDarkLightColor = .init(lightColor: .black, darkColor: .white)
    
    /// Set the legend titles of Funnel Chart, the count must be the same as the count of inputDatas
    public var inputLegendTitles: [String] = []
    
    /// The display type of data value, raw value by default
    public var displayDataMode: ChartValueDisplayMode = .original
    
    /// Funnel Chart initialization
    /// - Parameter inputDatas: An array of eligible chart data
    public init(inputDatas: [(Double, LiteChartDarkLightColor)]) {
        self.inputDatas = inputDatas
    }
    
    /// Conform to LiteChartParametersProcesser protocol, pass parameters to the underlying processing, determine their legitimacy and do other calculations.
    public var parametersProcesser: LiteChartParametersProcesser {
        FunalChartParameters(inputDatas: inputDatas, inputLegendTitles: inputLegendTitles, displayDataMode: displayDataMode, valueTextColor: valueTextColor)
    }
}
