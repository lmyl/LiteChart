//
//  ScatterPlotChartParameters.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/20.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

struct ScatterPlotChartParameters {
    var borderStyle: BarChartViewBorderStyle
    
    var borderColor: LiteChartDarkLightColor
    
    var textColor: LiteChartDarkLightColor
    
    var inputDatas: [(LiteChartDarkLightColor, Legend , [CGPoint])]
        
    var inputLegendTitles: [String]? // 图例显示
            
    var dividingValueLineStyle: AxisViewLineStyle
    
    var dividingValueLineColor: LiteChartDarkLightColor
    
    var dividingCoupleLineStyle: AxisViewLineStyle
    
    var dividingCoupleLineColor: LiteChartDarkLightColor
    
    var isShowValueDividingLine: Bool
    
    var isShowCoupleDividingLine: Bool
    
    var valueUnitString: String?
    
    var coupleUnitString: String?
    
    var axisColor: LiteChartDarkLightColor
    
    init(borderStyle: BarChartViewBorderStyle, borderColor: LiteChartDarkLightColor, textColor: LiteChartDarkLightColor, inputDatas: [(LiteChartDarkLightColor, Legend , [CGPoint])], inputLegendTitles: [String]?, dividingValueLineStyle: AxisViewLineStyle, dividingValueLineColor: LiteChartDarkLightColor, dividingCoupleLineStyle: AxisViewLineStyle, dividingCoupleLineColor: LiteChartDarkLightColor, isShowValueDividingLine: Bool, isShowCoupleDividingLine: Bool, valueUnitString: String?, coupleUnitString: String?, axisColor: LiteChartDarkLightColor) {
        self.borderStyle = borderStyle
        self.borderColor = borderColor
        self.inputDatas = inputDatas
        self.textColor = textColor
        self.inputLegendTitles = inputLegendTitles
        self.dividingValueLineColor = dividingValueLineColor
        self.dividingValueLineStyle = dividingValueLineStyle
        self.dividingCoupleLineColor = dividingCoupleLineColor
        self.dividingCoupleLineStyle = dividingCoupleLineStyle
        self.isShowValueDividingLine = isShowValueDividingLine
        self.isShowCoupleDividingLine = isShowCoupleDividingLine
        self.valueUnitString = valueUnitString
        self.coupleUnitString = coupleUnitString
        self.axisColor = axisColor
    }
}

extension ScatterPlotChartParameters: LiteChartParametersProcesser {
    func checkInputDatasParameterInvalid() throws {
        
    }

    func computeLegendViewConfigure() -> LegendViewsConfigure? {
        guard let inputLegendTitles = self.inputLegendTitles, inputLegendTitles.count == self.inputDatas.count else {
            return nil
        }
        var legendViewConfigures: [LegendViewConfigure] = []
        for index in 0 ..< self.inputDatas.count {
            let legendType = self.inputDatas[index].1
            let displayLabelConfigure = DisplayLabelConfigure(contentString: inputLegendTitles[index], contentColor: textColor, textAlignment: .left)
            let legendConfigure = LegendConfigure(color: self.inputDatas[index].0)
            let legendViewConfigure = LegendViewConfigure(legendType: legendType, legendConfigure: legendConfigure, contentConfigure: displayLabelConfigure)
            legendViewConfigures.append(legendViewConfigure)
            
        }
        return LegendViewsConfigure(models: legendViewConfigures)
    }

    func computeContentView() -> UIView {
        guard self.inputDatas.count > 0 else {
            let configure = PlotChartViewConfigure()
            return PlotChartView(configure: configure)
        }
        let coupleCount = self.inputDatas.count
        var coupleDatas: [[CGPoint]] = Array(repeating: [], count: coupleCount)
        for index in 0 ..< coupleCount {
            coupleDatas[index] = self.inputDatas[index].2
        }
        
        var inputDatas: [(LiteChartDarkLightColor, Legend , [(CGFloat, CGFloat, CGPoint)])] = []
        let valueForAxis = self.positiveAndNegativeValueForAxis(input: coupleDatas)
        
        let proportionPoint = self.computeProportionalValue(for: coupleDatas, xAxisValue: valueForAxis.xAxisValue, yAxisValue: valueForAxis.yAxisValue)
        
        guard proportionPoint.count == self.inputDatas.count else {
            fatalError("框架内部数据处理错误，不给予拯救")
        }

        for index in 0 ..< self.inputDatas.count {
            var datas: [(CGFloat, CGFloat, CGPoint)] = []
            let points = proportionPoint[index]
            for point in points {
                datas.append((1, 1, point))
            }
            inputDatas.append((self.inputDatas[index].0, self.inputDatas[index].1, datas))
        }
        
        var valuesString: [String] = []
        var valueDividingLineConfigure: [AxisDividingLineConfigure] = []
        if self.isShowValueDividingLine {
            let dividingPoints = valueForAxis.yDividingPoints
            let dividingValue = self.computeProportionalValue(for: dividingPoints, axisValue: valueForAxis.yAxisValue)
            valuesString = self.computeValueTitleString(dividingPoints)
            for value in dividingValue {
                let configure = AxisDividingLineConfigure(dividingLineStyle: self.dividingValueLineStyle, dividingLineColor: self.dividingValueLineColor, location: CGFloat(value))
                valueDividingLineConfigure.append(configure)
            }
        }
        
        var coupleTitleString: [String] = []
        var coupleDividingLineConfigure: [AxisDividingLineConfigure] = []
        if self.isShowCoupleDividingLine {
            let dividingPoints = valueForAxis.xDividingPoints
            let dividingValue = self.computeProportionalValue(for: dividingPoints, axisValue: valueForAxis.xAxisValue)
            coupleTitleString = self.computeValueTitleString(dividingPoints)
            for value in dividingValue {
                let configure = AxisDividingLineConfigure(dividingLineStyle: self.dividingValueLineStyle, dividingLineColor: self.dividingValueLineColor, location: CGFloat(value))
                coupleDividingLineConfigure.append(configure)
            }
        }
        
        let axisOriginal = self.computeOriginalValueForAxis(xAxisValue: valueForAxis.xAxisValue, yAxisValue: valueForAxis.yAxisValue)
        let plotChartViewConfigure = PlotChartViewConfigure(textColor: self.textColor, coupleTitle: coupleTitleString, valueTitle: valuesString, inputDatas: inputDatas, borderColor: self.borderColor, borderStyle: self.borderStyle, axisOriginal: axisOriginal, axisColor: self.axisColor, xDividingPoints: coupleDividingLineConfigure, yDividingPoints: valueDividingLineConfigure, valueUnitString: self.valueUnitString, coupleUnitString: self.coupleUnitString)
        return PlotChartView(configure: plotChartViewConfigure)
    }
    
    
    private func positiveAndNegativeValueForAxis(input datas: [[CGPoint]]) -> (xAxisValue: (Double, Double), yAxisValue: (Double, Double) , xDividingPoints: [Double], yDividingPoints: [Double]) {
        
        var xMaxValue: CGFloat
        var xMinValue: CGFloat
        var yMaxValue: CGFloat
        var yMinValue: CGFloat
        
        if datas.isEmpty {
            fatalError("内部数据处理错误，不给予拯救")
        } else if !datas.isEmpty && datas[0].isEmpty {
            xMaxValue = 0
            xMinValue = 0
            yMaxValue = 0
            yMinValue = 0
        } else {
            xMaxValue = datas[0][0].x
            xMinValue = xMaxValue
            yMaxValue = datas[0][0].y
            yMinValue = yMaxValue
            for data in datas {
                let xyValue: (x: [CGFloat], y: [CGFloat]) = data.reduce(([], [])){
                    inital, new in
                    var now = inital
                    now.0.append(new.x)
                    now.1.append(new.y)
                    return now
                }
                let xMaxCur = xyValue.x.max()
                let xMinCur = xyValue.x.min()
                if let xMaximum = xMaxCur, let xMinimum = xMinCur {
                    xMaxValue = max(xMaximum, xMaxValue)
                    xMinValue = min(xMinimum, xMinValue)
                }
                let yMaxCur = xyValue.y.max()
                let yMinCur = xyValue.y.min()
                if let yMaximum = yMaxCur, let yMinimum = yMinCur {
                    yMaxValue = max(yMaximum, yMaxValue)
                    yMinValue = min(yMinimum, yMinValue)
                }
            }
        }
        
        xMaxValue = xMaxValue / 0.75
        xMinValue = xMinValue / 0.75
        yMinValue = yMinValue / 0.75
        yMaxValue = yMaxValue / 0.75
        
        let xMaxAndMinAndDividingPoint = self.caculateValueAndDividingPointForAxis(input: (Double(xMaxValue), Double(xMinValue)))
        let yMaxAndMinAndDividingPoint = self.caculateValueAndDividingPointForAxis(input: (Double(yMaxValue), Double(yMinValue)))
        return (xMaxAndMinAndDividingPoint.axisValue, yMaxAndMinAndDividingPoint.axisValue, xMaxAndMinAndDividingPoint.dividingPoints, yMaxAndMinAndDividingPoint.dividingPoints)
        
    }
    
    private func computeOriginalValueForAxis(xAxisValue: (maxValue: Double, minValue: Double), yAxisValue: (maxValue: Double, minValue: Double)) -> CGPoint {
        var result = CGPoint.zero
        if xAxisValue.minValue > 0 {
            result.x = 0
        } else if xAxisValue.maxValue < 0 {
            result.x = 1
        } else {
            let sumValue = xAxisValue.maxValue + abs(xAxisValue.minValue)
            let xOffset = abs(xAxisValue.minValue) / sumValue
            result.x = CGFloat(xOffset)
        }
        
        if yAxisValue.minValue > 0 {
            result.y = 0
        } else if xAxisValue.maxValue < 0 {
            result.y = 1
        } else {
            let sumValue = yAxisValue.maxValue + abs(yAxisValue.minValue)
            let yOffset = abs(yAxisValue.minValue) / sumValue
            result.y = CGFloat(yOffset)
        }
        
        return result
    }
    
    private func computeOriginalValue(for datas: [[Double]]) -> [[Double]] {
        return datas
    }
    
    private func computeProportionalValue(for datas: [[CGPoint]], xAxisValue: (maxValue: Double, minValue: Double), yAxisValue: (maxValue: Double, minValue: Double)) -> [[CGPoint]] {
        var result = datas
        if xAxisValue.minValue >= 0 { // 均为正数
            let sumValue = CGFloat(xAxisValue.maxValue)
            result = result.map{
                $0.map{
                    inital in
                    var result = inital
                    result.x = result.x / sumValue
                    return result
                }
            }
        } else if xAxisValue.maxValue < 0 { // 均为负数
            let sumValue = CGFloat(abs(xAxisValue.minValue))
            result = result.map{
                $0.map{
                    inital in
                    var result = inital
                    result.x = (sumValue + result.x) / sumValue
                    return result
                }
            }
        } else { // 有正有负
            let sumValue = CGFloat(xAxisValue.maxValue + abs(xAxisValue.minValue))
            result = result.map{
                $0.map{
                    inital in
                    var result = inital
                    result.x = (result.x + CGFloat(abs(xAxisValue.minValue))) / sumValue
                    return result
                }
            }
        }
        
        if yAxisValue.minValue > 0 { // 均为正数
            let sumValue = CGFloat(yAxisValue.maxValue)
            result = result.map{
                $0.map{
                    inital in
                    var result = inital
                    result.y = result.y / sumValue
                    return result
                }
            }
        } else if yAxisValue.maxValue < 0 { // 均为负数
            let sumValue = CGFloat(abs(yAxisValue.minValue))
            result = result.map{
                $0.map{
                    inital in
                    var result = inital
                    result.y = (sumValue + result.y) / sumValue
                    return result
                }
            }
        } else { // 有正有负
            let sumValue = CGFloat(yAxisValue.maxValue + abs(yAxisValue.minValue))
            result = result.map{
                $0.map{
                    inital in
                    var result = inital
                    result.y = (result.y + CGFloat(abs(yAxisValue.minValue))) / sumValue
                    return result
                }
            }
        }
        
        return result
        
    }
    
    private func computeProportionalValue(for datas: [Double], axisValue: (maxValue: Double, minValue: Double)) -> [Double] {
        if axisValue.minValue > 0 { // 均为正数
            let sumValue = axisValue.maxValue
            return datas.map{
                $0 / sumValue
            }
        } else if axisValue.maxValue < 0 { // 均为负数
            let sumValue = abs(axisValue.minValue)
            return datas.map{
                (sumValue + $0) / sumValue
            }
        } else { // 有正有负
            let sumValue = axisValue.maxValue + abs(axisValue.minValue)
            return datas.map{
               ($0 + abs(axisValue.minValue)) / sumValue
            }
        }
    }
    
    private func caculateValueAndDividingPointForAxis(input data: (maxValue: Double, minValue: Double)) -> (axisValue: (Double, Double), dividingPoints: [Double]) {
        // 判断0
        var tempData = data
        
        if data.maxValue == 0 {
            tempData.maxValue = 1
        }
        
        if data.minValue == 0 {
            tempData.minValue = -1
        }
        
        let inputData = max(abs(tempData.0), abs(tempData.1))
        var firstNum: Int = 0
        var strInput = String(inputData)
        for char in strInput { // 获得首位数
            if char != "0" && char != "." && char != "-" {
                guard let num = Int(String(char)) else {
                    fatalError("内部数据处理错误，不给予拯救")
                }
                firstNum = num
                break
            }
        }
        // 计算单位量
        var standard:Double
        var count:Double = 0
        if inputData < 1 {
            strInput.removeFirst(2)
            for char in strInput {
                if char == "0" {
                    count += 1
                } else { break }
            }
            standard = pow(0.1, count+1)
        } else {
            for char in strInput {
                if char != "." {
                    count += 1
                } else { break }
            }
            standard = pow(10, count-1)
        }
        let base: Double = standard * Double(firstNum)
        let remainder: Double = inputData - base
        var value: Double
        
        // 计算分割线的顶格值
        if remainder == 0.0 {
            value =  inputData
        } else {
            switch firstNum {
            case 1:
                if remainder < standard / 5 {
                    value =  base + standard / 5
                } else if remainder < standard / 2 {
                    value =  base + standard / 2
                } else if remainder < standard * 4 / 5 {
                    value =  base + standard * 4 / 5
                } else {
                    value =  base + standard
                }
            case 2, 3:
                if remainder < standard / 2 {
                    value =  base + standard / 2
                } else {
                    value =  base + standard
                }
            case 4, 5, 6, 7:
                value =  base + standard
            case 8,9:
                value =  standard * 10
            default:
                fatalError("内部数据处理错误，不给予拯救")
            }
        }
        // 计算要分割数据的份数
        var tempValue:Double = value
        while tempValue < 100 {
            tempValue *= 10
        }
        let strValue = String(tempValue).prefix(2)
        var dividingPart:Int = 0
        switch strValue {
        case "20", "40", "80":
            dividingPart = 4
        case "15", "25", "50":
            dividingPart = 5
        case "30", "60", "12", "18":
            dividingPart = 6
        case "35", "70":
            dividingPart = 7
        case "90":
            dividingPart = 9
        case "10":
            dividingPart = 10
        default:
            fatalError("内部数据处理错误，不给予拯救")
        }
        let dividingInterval = value / Double(dividingPart)
                
        if tempData.maxValue >= 0 && tempData.minValue >= 0 {
            var dividingPoint: [Double] = []
            for index in 0 ... dividingPart {
                dividingPoint.append(Double(index) * dividingInterval)
            }
            let maxAxisValue = value
            let minAxisValue = 0.0
            dividingPoint.removeLast()
            dividingPoint.removeFirst()
            return ((maxAxisValue, minAxisValue), dividingPoint)
        } else if tempData.minValue < 0 && tempData.maxValue < 0 {
            var dividingPoint: [Double] = []
            for index in 0 ... dividingPart {
                dividingPoint.append( 0 - Double(index) * dividingInterval)
            }
            dividingPoint = dividingPoint.reversed()
            let maxAxisValue = 0.0
            let minAxisValue = -value
            dividingPoint.removeLast()
            dividingPoint.removeFirst()
            return ((maxAxisValue, minAxisValue), dividingPoint)
        } else if tempData.maxValue >= abs(tempData.minValue) { // 正数部分较大
            var dividingPoint: [Double] = []
            var count = 1
            while abs(tempData.minValue) > Double(count) * dividingInterval {
                count += 1
            }
            for index in 1 ... count {
                dividingPoint.append(0 - Double(index) * dividingInterval)
            }
            dividingPoint = dividingPoint.reversed()
            for index in 0 ... dividingPart {
                dividingPoint.append(Double(index) * dividingInterval)
            }
            let maxAxisValue = value
            let minAxisValue = tempData.minValue
            dividingPoint.removeLast()
            dividingPoint.removeFirst()
            return ((maxAxisValue, minAxisValue), dividingPoint)
        } else { // 负数部分较大
            var dividingPoint: [Double] = []
            for index in 0 ... dividingPart {
                dividingPoint.append(0 - Double(index) * dividingInterval)
            }
            dividingPoint = dividingPoint.reversed()
            var count = 1
            while tempData.maxValue > Double(count) * dividingInterval {
                count += 1
            }
            for index in 1 ... count {
                dividingPoint.append(Double(index) * dividingInterval)
            }
            let maxAxisValue = tempData.maxValue
            let minAxisValue = -value
            dividingPoint.removeLast()
            dividingPoint.removeFirst()
            return ((maxAxisValue, minAxisValue), dividingPoint)
        }
        
    }
    
    
    private var displayOriginalFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.positiveFormat = ",###.##"
        return formatter
    }
    
    private var displayValueTitleFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.positiveFormat = ",###.##"
        return formatter
    }
    
    private func computeOriginalString(for datas: [[Double]]) -> [[String]] {
        let formatter = self.displayOriginalFormatter
        return self.computeOriginalValue(for: datas).map{ value in
            value.map{
                let nsNumber = $0 as NSNumber
                return formatter.string(from: nsNumber) ?? "Data Error!"
            }
        }
    }
    
    private func computeValueTitleString(_ datas: [Double]) -> [String] {
        let formatter = self.displayValueTitleFormatter
        let datasString: [String] = datas.map{
            let nsNumber = $0 as NSNumber
            return formatter.string(from: nsNumber) ?? "Data Error !"
        }
        var maxDigital = 0
        for string in datasString {
            let remain = string.split(separator: ".")
            guard remain.count == 2 else {
                continue
            }
            maxDigital = max(maxDigital, remain[1].count)
        }
        var results: [String] = []
        for string in datasString {
            let remain = string.split(separator: ".")
            if remain.count == 2 && remain[1].count < maxDigital {
                let zeroString = String.init(repeating: "0", count: maxDigital - remain[1].count)
                results.append(string + zeroString)
            } else if remain.count == 1 && maxDigital > 0 {
                let zeroString = String.init(repeating: "0", count: maxDigital)
                results.append(string + "." + zeroString)
            } else {
                results.append(string)
            }
        }
        return results
    }
    
    
}
