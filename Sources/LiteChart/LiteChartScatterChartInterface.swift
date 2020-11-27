//
//  LiteChartScatterChartInterface.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/10/10.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation
import CoreGraphics

/// Parameters interface of Scatter chart
public struct LiteChartScatterChartInterface: LiteChartInterface {
    
    /// Set the type of chart border
    public var borderStyle: LiteChartViewBorderStyle = .halfSurrounded
    
    /// Set the color used in the underlying drawing(including dividing lines, value titles and couple titles)
    public var underlayerColor: LiteChartDarkLightColor = .init(lightColor: .black, darkColor: .white)
    
    /// Set the legend title of chart, the count must be the same as the count of inputDatas
    public var inputLegendTitles: [String] = []
    
    /// An array of eligible chart data, including scatter's color, legend type and an array of `CGPoint` to display.
    public var inputDatas: [(LiteChartDarkLightColor, Legend , [CGPoint])]
    
    /// Whether to display the value dividing line (Horizontal)
    public var isShowValueDividingLine = false
    
    /// Value dividing line display type
    public var dividingValueLineStyle: AxisViewLineStyle = .dotted
    
    /// Wheter to display the couple dividing line (Vertical)
    public var isShowCoupleDividingLine = false
    
    /// Couple dividing line display type
    public var dividingCoupleLineStyle: AxisViewLineStyle = .dotted
    
    /// Whether to display value unit title, false by default
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
    
    /// Scatter chart initialization
    /// - Parameter inputDatas: A set of eligible chart data
    public init(inputDatas: [(LiteChartDarkLightColor, Legend , [CGPoint])]) {
        self.inputDatas = inputDatas
    }
    
    /// Conform to LiteChartParametersProcesser protocol, pass parameters to the underlying processing, determine their legitimacy and do other calculations.
    public var parametersProcesser: LiteChartParametersProcesser {
        ScatterPlotChartParameters(borderStyle: borderStyle, borderColor: underlayerColor, inputLegendTitles: inputLegendTitles, inputDatas: inputDatas, valueTextColor: underlayerColor, coupleTextColor: underlayerColor, isShowValueDividingLine: isShowValueDividingLine, dividingValueLineStyle: dividingValueLineStyle, dividingValueLineColor: underlayerColor, isShowCoupleDividingLine: isShowCoupleDividingLine, dividingCoupleLineStyle: dividingCoupleLineStyle, dividingCoupleLineColor: underlayerColor, isShowValueUnitString: isShowValueUnitString, valueUnitString: valueUnitString, isShowCoupleUnitString: isShowCoupleUnitString, coupleUnitString: coupleUnitString, valueUnitTextColor: unitTextColor, coupleUnitTextColor: unitTextColor, axisColor: axisColor, isShowAxis: isShowAxis)
    }
}
