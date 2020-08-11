//
//  BarChartViewParameter.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/11.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation
import UIKit

struct BarChartParameter {
    
    var borderStyle: BarChartViewBorderStyle
    
    var borderColor: LiteChartDarkLightColor
    
    var direction: BarChartDirection
    
    var textColor: LiteChartDarkLightColor
    
    var inputDatas: [(LiteChartDarkLightColor, [Double])]
    
    var coupleTitle: [String]
    
    var inputLegendTitles: [String]
    
    var displayDataMode: ChartValueDisplayMode
    
    var dividingValueLineStyle: AxisViewLineStyle
    
    var dividingValueLineColor: LiteChartDarkLightColor
    
    var dividingCoupleLineStyle: AxisViewLineStyle
    
    var dividingCoupleLineColor: LiteChartDarkLightColor
    
    var isShowValueDividingLine: Bool
    
    var isShowCoupleDividingLine: Bool
    
    var isShowValueUnitString: Bool
    
    var isShowCoupleUnitString: Bool
    
    var valueUnitString: String
    
    var coupleUnitString: String
    
    init(borderStyle: BarChartViewBorderStyle, borderColor: LiteChartDarkLightColor, direction: BarChartDirection, textColor: LiteChartDarkLightColor, inputDatas: [(LiteChartDarkLightColor, [Double])], coupleTitle: [String], displayDataMode: ChartValueDisplayMode, dividingLineStyle: AxisViewLineStyle, dividingLineColor: LiteChartDarkLightColor, isShowValueDividingLine: Bool, inputLegendTitles: [String], isShowCoupleDividingLine: Bool, dividingCoupleLineStyle: AxisViewLineStyle, dividingCoupleLineColor: LiteChartDarkLightColor, isShowValueUnitString: Bool, valueUnitString: String, isShowCoupleUnitString: Bool, coupleUnitString: String) {
        self.borderStyle = borderStyle
        self.borderColor = borderColor
        self.direction = direction
        self.textColor = textColor
        self.displayDataMode = displayDataMode
        self.dividingValueLineStyle = dividingLineStyle
        self.dividingValueLineColor = dividingLineColor
        self.isShowValueDividingLine = isShowValueDividingLine
        self.inputLegendTitles = inputLegendTitles
        self.isShowCoupleDividingLine = isShowCoupleDividingLine
        self.dividingCoupleLineColor = dividingCoupleLineColor
        self.dividingCoupleLineStyle = dividingCoupleLineStyle
        
        self.inputDatas = inputDatas
        self.coupleTitle = coupleTitle
        
        self.isShowValueUnitString = isShowValueUnitString
        self.isShowCoupleUnitString = isShowCoupleUnitString
        self.valueUnitString = valueUnitString
        self.coupleUnitString = coupleUnitString
    }
    
}

extension BarChartParameter: LiteChartParametersProcesser {
    func checkInputDatasParameterInvalid() throws {
        let inputDatas = self.inputDatas
        if inputDatas.count > 0 {
            let firstDataCount = inputDatas[0].1.count
            if firstDataCount != self.coupleTitle.count {
                throw ChartError.inputDatasNumbersNotMatchedCoupleTitle
            }
            for inputData in inputDatas {
                if inputData.1.count != firstDataCount {
                    throw ChartError.inputDatasNumberMustEqualForCouple
                }
                let contains = inputData.1.contains(where: {
                    $0 < 0
                })
                if contains {
                    throw ChartError.inputDatasMustPositive
                }
            }
        }
    }
    
    func computeLegendViewConfigure() -> LegendViewsConfigure? {
        guard self.inputDatas.count == self.inputLegendTitles.count else {
            return nil
        }
        var legendViewConfigures: [LegendViewConfigure] = []
        for index in 0 ..< self.inputDatas.count {
            let legendType = Legend.square
            let displayLabelConfigure = DisplayLabelConfigure(contentString: inputLegendTitles[index], contentColor: textColor, textAlignment: .left)
            let legendConfigure = LegendConfigure(color: self.inputDatas[index].0)
            let legendViewConfigure = LegendViewConfigure(legendType: legendType, legendConfigure: legendConfigure, contentConfigure: displayLabelConfigure)
            legendViewConfigures.append(legendViewConfigure)
        }
        return LegendViewsConfigure(models: legendViewConfigures)
    }
    
    func computeContentView() -> UIView {
        
        guard self.inputDatas.count > 0 else {
            let configure = BarChartViewConfigure.emptyConfigure
            return BarChartView(configure: configure)
        }
        
        let coupleCount = self.inputDatas.count
        var coupleDatas: [[Double]] = Array(repeating: [], count: coupleCount)
        for index in 0 ..< coupleCount { 
            coupleDatas[index] = self.inputDatas[index].1
        }
        
        var displayString: [[String]] = Array(repeating: [], count: coupleCount)
        switch self.displayDataMode {
        case .original:
            displayString = self.computeOriginalString(for: coupleDatas)
        case .none, .mix, .percent:
            displayString = []
        }
        
        
        let valueForAxis = self.maxValueAndDividingPointForAxis(input: coupleDatas)
        
        
        var inputDatas: [(LiteChartDarkLightColor, [(String, CGFloat)])] = []
        let proportionalValue = self.computeProportionalValue(for: coupleDatas, maxValue: valueForAxis.maxValue)
        
        for index in 0 ..< self.inputDatas.count {
            var datas: [(String, CGFloat)] = []
            for innerIndex in 0 ..< self.inputDatas[index].1.count {
                if self.displayDataMode == .original {
                    let string = displayString[index][innerIndex]
                    datas.append((string, CGFloat(proportionalValue[index][innerIndex])))
                } else {
                    datas.append(("", CGFloat(proportionalValue[index][innerIndex])))
                }
                
            }
            inputDatas.append((self.inputDatas[index].0, datas))
        }
        
        //Todo: 计算value分割线位置
        
        var valuesString: [String] = []
        var valueDividingLineConfigure: [AxisDividingLineConfigure] = []
        
        if self.isShowValueDividingLine {
            let dividingNumber = valueForAxis.dividingPoint
            valuesString = self.computeValueTitleString(dividingNumber)
            let dividingValue = self.computeProportionalValue(for: dividingNumber, maxValue: valueForAxis.maxValue)
            for value in dividingValue {
                let configure = AxisDividingLineConfigure(dividingLineStyle: self.dividingValueLineStyle, dividingLineColor: self.dividingValueLineColor, location: CGFloat(value))
                valueDividingLineConfigure.append(configure)
            }
        }
        
        
        //Todo: 计算couple分割线位置
        let coupleTitles = self.coupleTitle
        var coupleDividingLineConfigrue: [AxisDividingLineConfigure] = []
        let numberCount = self.inputDatas[0].1.count
        if self.isShowCoupleDividingLine && numberCount >= 2 {
            let space: CGFloat = 1 / CGFloat(numberCount)
            for index in 1 ..< numberCount {
                let configure = AxisDividingLineConfigure(dividingLineStyle: self.dividingCoupleLineStyle, dividingLineColor: self.dividingCoupleLineColor, location: space * CGFloat(index))
                coupleDividingLineConfigrue.append(configure)
            }
        }
        
        let isShowLabel = self.displayDataMode == .original
        switch self.direction {
        case .bottomToTop:
            let barChartViewConfigure = BarChartViewConfigure(textColor: textColor, coupleTitle: coupleTitles, valueTitle: valuesString, inputDatas: inputDatas, isShowLabel: isShowLabel, direction: .bottomToTop, borderColor: self.borderColor, borderStyle: self.borderStyle, xDividingPoints: coupleDividingLineConfigrue, yDividingPoints: valueDividingLineConfigure, isShowValueUnitString: self.isShowValueUnitString, isShowCoupleUnitString: self.isShowCoupleUnitString, valueUnitString: self.valueUnitString, coupleUnitString: self.coupleUnitString)
            return BarChartView(configure: barChartViewConfigure)
        case .leftToRight:
            let barChartViewConfigure = BarChartViewConfigure(textColor: textColor, coupleTitle: coupleTitles, valueTitle: valuesString, inputDatas: inputDatas, isShowLabel: isShowLabel, direction: .leftToRight, borderColor: self.borderColor, borderStyle: self.borderStyle, xDividingPoints: valueDividingLineConfigure, yDividingPoints: coupleDividingLineConfigrue,isShowValueUnitString: self.isShowValueUnitString, isShowCoupleUnitString: self.isShowCoupleUnitString, valueUnitString: self.valueUnitString, coupleUnitString: self.coupleUnitString)
            return BarChartView(configure: barChartViewConfigure)
        }
        
    }
    
    private func maxValueAndDividingPointForAxis(input datas: [[Double]]) -> (maxValue: Double, dividingPoint: [Double]) {
        var maxValue = 0.0
        for input in datas {
            let max = input.max()
            if let m = max {
                maxValue = m
            }
        }
        if maxValue == 0 {
            maxValue = 1
        }
        maxValue = maxValue / 0.75
        return self.caculateMaxValueAndDividingPointForAxis(input: maxValue)
    }
    
    private func caculateMaxValueAndDividingPointForAxis(input maxData: Double) -> (maxValue: Double, dividingPoint: [Double]) {
       
        var inputData = maxData
        if inputData == 0 {
            inputData = 1
        }

        var firstNum: Int = 0
        var strInput = String(inputData)
        for char in strInput { // 获得首位数
            if char != "0" && char != "." {
                guard let num = Int(String(char)) else {
                    fatalError("内部数据处理错误，不给予拯救")
                }
                firstNum = num
                break
            }
        }

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
        var dividingPoints = [Double]()
        for index in 1 ..< dividingPart {
            dividingPoints.append(value / Double(dividingPart) * Double(index))
        }
        return (value, dividingPoints)
    }
    
    private func computeOriginalValue(for datas: [[Double]]) -> [[Double]] {
        return datas
    }
    
    private func computeProportionalValue(for datas: [[Double]], maxValue: Double) -> [[Double]] {
        return datas.map{
            $0.map{
                $0 / maxValue
            }
        }
    }
    
    private func computeProportionalValue(for datas: [Double], maxValue: Double) -> [Double] {
        return datas.map{
            $0 / maxValue
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
        return self.computeOriginalValue(for: datas).map{
            value in
            value.map{
            let nsNumber = $0 as NSNumber
            return formatter.string(from: nsNumber) ?? "Data Error !"
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
            } else if remain.count == 1 && maxDigital > 0{
                let zeroString = String.init(repeating: "0", count: maxDigital)
                results.append(string + "." + zeroString)
            } else {
                results.append(string)
            }
            
        }
        return results
    }
    
}
