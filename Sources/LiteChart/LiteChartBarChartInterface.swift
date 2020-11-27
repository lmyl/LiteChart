//
//  LiteChartBarChartInterface.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/10/9.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation

/// Parameters interface of Bar Chart
public struct LiteChartBarChartInterface: LiteChartInterface {
    /// An array of eligible chart data, including bar color and an array of `Double` to display.
    public var inputDatas: [(LiteChartDarkLightColor, [Double])]
    
    /// Set the couple titles of chart, the count must be the same as the count of data in each group
    public var coupleTitle: [String]
    
    /// Set the type of chart border, halfSurrounded by default
    public var borderStyle: LiteChartViewBorderStyle = .halfSurrounded
    
    /// Set the color used in the underlying drawing(including dividing lines, value titles and couple titles)
    public var underlayerColor: LiteChartDarkLightColor = .init(lightColor: .black, darkColor: .white)
    
    /// The direction of the histogram, vertical by default
    public var direction: BarChartDirection = .bottomToTop
    
    /// The display type  of data value, original by default
    public var displayDataMode: ChartValueDisplayMode = .original
    
    /// Set the legend titles of bar chart, the count must be the same as the count of inputDatas
    public var inputLegendTitles: [String] = []
    
    /// Whether to display the value dividing line (Vertical in bottomToTop)
    public var isShowValueDividingLine = true
    
    /// Value dividing line display type, dotted by default
    public var dividingValueLineStyle: AxisViewLineStyle = .dotted
    
    /// Whether to display the couple dividing line (Horizontal in bottomToTop)
    public var isShowCoupleDividingLine = true
    
    /// Couple dividing line display, dotted by default
    public var dividingCoupleLineStyle: AxisViewLineStyle = .dotted
    
    /// Whether to display value unit title, false by default
    public var isShowValueUnitString = false
    
    /// Whether to display couple unit title, false by default
    public var isShowCoupleUnitString = false
    
    /// Set the color of unit text color
    public var unitTextColor: LiteChartDarkLightColor = .init(lightColor: .black, darkColor: .white)
    
    /// Set the content of value unit title
    public var valueUnitString = ""
    
    /// Set the content of couple unit title
    public var coupleUnitString = ""
    
    /// Bar Chart initialization
    /// - Parameters:
    ///   - inputDatas: An array of eligible chart data
    ///   - coupleTitle: An array of couple titles of chart, the count is the same as the count of data arrays.
    public init(inputDatas: [(LiteChartDarkLightColor, [Double])], coupleTitle: [String]) {
        self.inputDatas = inputDatas
        self.coupleTitle = coupleTitle
    }
    
    /// Conform to LiteChartParametersProcesser protocol, pass parameters to the underlying processing, determine their legitimacy and do other calculations.
    public var parametersProcesser: LiteChartParametersProcesser {
        BarChartParameter(borderStyle: borderStyle, borderColor: underlayerColor, direction: direction, displayDataMode: displayDataMode, inputLegendTitles: inputLegendTitles, inputDatas: inputDatas, valueTextColor: underlayerColor, coupleTitle: coupleTitle, coupleTextColor: underlayerColor, isShowValueDividingLine: isShowValueDividingLine, dividingValueLineStyle: dividingValueLineStyle, dividingValueLineColor: underlayerColor, isShowCoupleDividingLine: isShowCoupleDividingLine, dividingCoupleLineStyle: dividingCoupleLineStyle, dividingCoupleLineColor: underlayerColor, isShowValueUnitString: isShowValueUnitString, isShowCoupleUnitString: isShowCoupleUnitString, valueUnitString: valueUnitString, coupleUnitString: coupleUnitString, valueUnitTextColor: unitTextColor, coupleUnitTextColor: unitTextColor)
    }
}
