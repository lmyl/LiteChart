//
//  LiteChartLineChartInterface.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/10/9.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation

/// Parameters interface of line chart
public struct LiteChartLineChartInterface: LiteChartInterface {
    /// Set the type of chart border, halfSurrounded by default
    public var borderStyle: LiteChartViewBorderStyle = .halfSurrounded
    
    /// Set the color used in the underlying drawing(including dividing lines, value titles and couple titles)
    public var underlayerColor: LiteChartDarkLightColor = .init(lightColor: .black, darkColor: .white)
    
    /// The display type of data value, original by default
    public var displayDataMode: ChartValueDisplayMode = .original
    
    /// Set the legend title of chart, the count of it must be the same as the count of inputDatas
    public var inputLegendTitles: [String] = []
    
    /// A array of eligible chart data, including single line's color, single line's style, legend type and an array of  `Double` to display.
    public var inputDatas: [(LiteChartDarkLightColor, LineStyle, Legend , [Double])]
    
    /// Set the couple titles of chart, the count of it must be the same as the count of data in each group
    public var coupleTitles: [String]
    
    /// Wheter to display the couple dividing line (Vertical)
    public var isShowValueDividingLine = false
    
    /// Value dividing line display type, dotted by default
    public var dividingValueLineStyle: AxisViewLineStyle = .dotted
    
    /// Whether to display couple dividing line, false by default (Horizontal)
    public var isShowCoupleDividingLine = false
    
    /// Couple dividing line display type
    public var dividingCoupleLineStyle: AxisViewLineStyle = .dotted
    
    /// Whther to display value unit title, false by default
    public var isShowValueUnitString = false
    
    /// Whether to display couple unit title, false by default
    public var isShowCoupleUnitString = false
    
    /// Set the content of value unit title
    public var valueUnitString = ""
    
    /// Set the content of couple unit title
    public var coupleUnitString = ""
    
    /// Set the color of unit text color
    public var unitTextColor: LiteChartDarkLightColor = .init(lightColor: .black, darkColor: .white)
    
    /// Set the color of chart's axes
    public var axisColor: LiteChartDarkLightColor = .init(lightColor: .black, darkColor: .white)
    
    /// Whether to display axes view, false by default
    public var isShowAxis = false
    
    /// Line chart initialization
    /// - Parameters:
    ///   - inputDatas: An array of eligible chart data
    ///   - coupleTitle: An array of couple titles of chart, the count is the same as the count of data arrays.
    public init(inputDatas: [(LiteChartDarkLightColor, LineStyle, Legend , [Double])], coupleTitle: [String]) {
        self.inputDatas = inputDatas
        self.coupleTitles = coupleTitle
    }
    
    /// Conform to LiteChartParametersProcesser protocol, pass parameters to the underlying processing, determine their legitimacy and do other calculations.
    public var parametersProcesser: LiteChartParametersProcesser {
        LineChartParameters(borderStyle: borderStyle, borderColor: underlayerColor, displayDataMode: displayDataMode, inputLegendTitles: inputLegendTitles, inputDatas: inputDatas, valueTextColor: underlayerColor, coupleTitles: coupleTitles, coupleTextColor: underlayerColor, isShowValueDividingLine: isShowValueDividingLine, dividingValueLineStyle: dividingValueLineStyle, dividingValueLineColor: underlayerColor, isShowCoupleDividingLine: isShowCoupleDividingLine, dividingCoupleLineStyle: dividingCoupleLineStyle, dividingCoupleLineColor: underlayerColor, isShowValueUnitString: isShowValueUnitString, valueUnitString: valueUnitString, valueUnitTextColor: unitTextColor, isShowCoupleUnitString: isShowCoupleUnitString, coupleUnitString: coupleUnitString, coupleUnitTextColor: unitTextColor, axisColor: axisColor, isShowAxis: isShowAxis)
    }
}
