//
//  BubbleChartParameters.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/20.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

struct BubbleChartParameters {
    var borderStyle: LiteChartViewBorderStyle
    
    var borderColor: LiteChartDarkLightColor
    
    var inputLegendTitles: [String] // 图例显示
    
    var inputDatas: [(LiteChartDarkLightColor, [(scale: CGFloat, location: CGPoint)])]
    
    var valueTextColor: LiteChartDarkLightColor
    
    var coupleTextColor: LiteChartDarkLightColor
    
    var isShowValueDividingLine: Bool
            
    var dividingValueLineStyle: AxisViewLineStyle
    
    var dividingValueLineColor: LiteChartDarkLightColor
    
    var isShowCoupleDividingLine: Bool
    
    var dividingCoupleLineStyle: AxisViewLineStyle
    
    var dividingCoupleLineColor: LiteChartDarkLightColor
    
    var isShowValueUnitString: Bool
    
    var isShowCoupleUnitString: Bool
    
    var valueUnitString: String
    
    var coupleUnitString: String
    
    var valueUnitTextColor: LiteChartDarkLightColor
    
    var coupleUnitTextColor: LiteChartDarkLightColor
    
    var axisColor: LiteChartDarkLightColor
    
    var isShowAxis: Bool
    
    init(borderStyle: LiteChartViewBorderStyle,
         borderColor: LiteChartDarkLightColor,
         inputLegendTitles: [String],
         inputDatas: [(LiteChartDarkLightColor, [(scale: CGFloat, location: CGPoint)])],
         valueTextColor: LiteChartDarkLightColor,
         coupleTextColor: LiteChartDarkLightColor,
         isShowValueDividingLine: Bool,
         dividingValueLineStyle: AxisViewLineStyle,
         dividingValueLineColor: LiteChartDarkLightColor,
         isShowCoupleDividingLine: Bool,
         dividingCoupleLineStyle: AxisViewLineStyle,
         dividingCoupleLineColor: LiteChartDarkLightColor,
         isShowValueUnitString: Bool,
         valueUnitString: String,
         valueUnitTextColor: LiteChartDarkLightColor,
         isShowCoupleUnitString: Bool,
         coupleUnitString: String,
         coupleUnitTextColor: LiteChartDarkLightColor,
         axisColor: LiteChartDarkLightColor,
         isShowAxis: Bool) {
        self.borderStyle = borderStyle
        self.borderColor = borderColor
        self.inputLegendTitles = inputLegendTitles
        self.inputDatas = inputDatas
        self.valueTextColor = valueTextColor
        self.coupleTextColor = coupleTextColor
        self.isShowValueDividingLine = isShowValueDividingLine
        self.dividingValueLineColor = dividingValueLineColor
        self.dividingValueLineStyle = dividingValueLineStyle
        self.isShowCoupleDividingLine = isShowCoupleDividingLine
        self.dividingCoupleLineColor = dividingCoupleLineColor
        self.dividingCoupleLineStyle = dividingCoupleLineStyle
        self.isShowCoupleUnitString = isShowCoupleUnitString
        self.isShowValueUnitString = isShowValueUnitString
        self.valueUnitString = valueUnitString
        self.coupleUnitString = coupleUnitString
        self.valueUnitTextColor = valueUnitTextColor
        self.coupleUnitTextColor = coupleUnitTextColor
        self.axisColor = axisColor
        self.isShowAxis = isShowAxis
    }
}

extension BubbleChartParameters: LiteChartParametersProcesser {
    func checkInputDatasParameterInvalid() throws {
        
    }

    func computeLegendViews() -> UIView? {
        guard self.inputLegendTitles.count == self.inputDatas.count else {
            return nil
        }
        var legendViewConfigures: [LegendViewConfigure] = []
        for index in 0 ..< self.inputDatas.count {
            let legendType = Legend.circle
            let displayLabelConfigure = DisplayLabelConfigure(contentString: inputLegendTitles[index], contentColor: self.inputDatas[index].0, textAlignment: .left, syncIdentifier: .bubbleLegendTitleLabel)
            let legendConfigure = LegendConfigure(type: legendType, color: self.inputDatas[index].0)
            let legendViewConfigure = LegendViewConfigure(legendConfigure: legendConfigure, contentConfigure: displayLabelConfigure)
            legendViewConfigures.append(legendViewConfigure)
            
        }
        let legendConfigure = LegendViewsConfigure(models: legendViewConfigures)
        return LegendViews(configure: legendConfigure)
    }

    func computeContentView() -> LiteChartContentView {
        guard self.inputDatas.count > 0 else {
            let configure = PlotChartViewConfigure.emptyConfigure
            return PlotChartView(configure: configure)
        }
        let coupleCount = self.inputDatas.count
        var coupleDatas: [[CGPoint]] = Array(repeating: [], count: coupleCount)
        var scaleDatas: [[CGFloat]] = Array(repeating: [], count: coupleCount)
        for index in 0 ..< coupleCount {
            coupleDatas[index] = self.inputDatas[index].1.map{
                $0.location
            }
            scaleDatas[index] = self.inputDatas[index].1.map{
                input in
                if input.scale < 1 {
                    return 1
                }
                return input.scale
            }
        }
        
        let opacityDatas = self.computeOpacityFromScale(scales: scaleDatas)
        
        var inputDatas: [(LiteChartDarkLightColor, Legend , [(CGFloat, CGFloat, CGPoint)])] = []
        let valueForAxis = self.positiveAndNegativeValueForAxis(input: coupleDatas)
        
        let proportionPoint = self.computeProportionalValue(for: coupleDatas, xAxisValue: valueForAxis.xAxisValue, yAxisValue: valueForAxis.yAxisValue)
        
        guard proportionPoint.count == self.inputDatas.count else {
            fatalError("框架内部数据处理错误，不给予拯救")
        }

        for index in 0 ..< self.inputDatas.count {
            var datas: [(CGFloat, CGFloat, CGPoint)] = []
            let points = proportionPoint[index]
            for ind in 0 ..< points.count {
                datas.append((scaleDatas[index][ind], opacityDatas[index][ind], points[ind]))
            }
            inputDatas.append((self.inputDatas[index].0, Legend.circle, datas))
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
        
        let valueUnitStringConfigure = DisplayLabelConfigure(contentString: self.valueUnitString, contentColor: self.valueUnitTextColor, textAlignment: .center, textDirection: .vertical, syncIdentifier: .pointsUnitTitleLabel)
        let coupleUnitStringConfigure = DisplayLabelConfigure(contentString: self.coupleUnitString, contentColor: self.coupleUnitTextColor, syncIdentifier: .pointsUnitTitleLabel)
        
        var coupleTitleConfigure: [DisplayLabelConfigure] = []
        for title in coupleTitleString {
            let configure = DisplayLabelConfigure(contentString: title, contentColor: self.coupleTextColor, syncIdentifier: .pointsCoupleTitleLabel)
            coupleTitleConfigure.append(configure)
        }
        
        var valueTitleConfigure: [DisplayLabelConfigure] = []
        for title in valuesString {
            let configure = DisplayLabelConfigure(contentString: title, contentColor: self.valueTextColor, textAlignment: .right, syncIdentifier: .pointsValueTitleLabel)
            valueTitleConfigure.append(configure)
        }
        
        let borderStlye = self.borderStyle.convertToAxisBorderStyle()
        let axisConfigure = AxisViewConfigure(originPoint: axisOriginal, axisColor: self.axisColor, verticalDividingPoints: valueDividingLineConfigure, horizontalDividingPoints: coupleDividingLineConfigure, borderStyle: borderStlye, borderColor: self.borderColor, isShowXAxis: self.isShowAxis, isShowYAxis: self.isShowAxis)
        
        var configures: [PointsViewConfigure] = []
        for inputData in inputDatas {
            var pointConfigure: [PointConfigure] = []
            for point in inputData.2 {
                let configure = PointConfigure(location: point.2, legendConfigure: .init(type: inputData.1, color: inputData.0), size: point.0, opacity: point.1)
                pointConfigure.append(configure)
            }
            let con = PointsViewConfigure(points: pointConfigure)
            configures.append(con)
        }
        let pointViewsConfigure = PointViewsConfigure(models: configures)
        
        let plotChartViewConfigure = PlotChartViewConfigure(isShowValueUnitString: self.isShowValueUnitString, isShowCoupleUnitString: self.isShowCoupleUnitString, axisConfigure: axisConfigure, valueUnitStringConfigure: valueUnitStringConfigure, coupleUnitStringConfigure: coupleUnitStringConfigure, coupleTitleConfigure: coupleTitleConfigure, valueTitleConfigure: valueTitleConfigure, pointViewsConfigure: pointViewsConfigure)
        
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
        if xAxisValue.minValue > 0 { // 均为正数
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
            let minAxisValue = 0 - Double(count) * dividingInterval
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
            let maxAxisValue = Double(count) * dividingInterval
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
    
    private func computeOpacityFromScale(scales: [[CGFloat]]) -> [[CGFloat]] {
        var maxValue: CGFloat = 1
        for scale in scales {
            for value in scale {
                maxValue = max(maxValue, value)
            }
        }
        maxValue = maxValue / 0.75
        var result: [[CGFloat]] = []
        for scale in scales {
            let opacitys = scale.map{
                1 - $0 / maxValue
            }
            result.append(opacitys)
        }
        return result
    }
    
}
