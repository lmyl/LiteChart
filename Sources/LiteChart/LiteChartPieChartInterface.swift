//
//  LiteChartPieChartInterface.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/10/9.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation

/// Parameters interface of Pie Chart
public struct LiteChartPieChartInterface: LiteChartInterface {
    /// An array of eligible chart data, including the color of the pie and the data corresponding to the pie.
    public var inputDatas: [(Double, LiteChartDarkLightColor)]
    
    /// Set the legend titles of Pie Chart, the count must be the same as the count of inputDatas
    public var inputLegendTitles: [String] = []
    
    /// The display type of data value, original by default
    public var displayDataMode: ChartValueDisplayMode = .original
    
    /// Pie Chart initialization
    /// - Parameter inputDatas: An array of eligible chart data
    public init(inputDatas: [(Double, LiteChartDarkLightColor)]) {
        self.inputDatas = inputDatas
    }
    
    /// Conform to LiteChartParametersProcesser protocol, pass parameters to the underlying processing, determine their legitimacy and do other calculations.
    public var parametersProcesser: LiteChartParametersProcesser {
        PieChartParameters(inputDatas: inputDatas, inputLegendTitles: inputLegendTitles, displayDataMode: displayDataMode)
    }
}
