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
    
    var borderStyle: LiteChartViewBorderStyle
    
    var borderColor: LiteChartDarkLightColor
    
    var direction: BarChartDirection
    
    var displayDataMode: ChartValueDisplayMode
    
    var inputLegendTitles: [String]
    
    var inputDatas: [(LiteChartDarkLightColor, [Double])]
    
    var valueTextColor: LiteChartDarkLightColor
    
    var coupleTitle: [String]
    
    var coupleTextColor: LiteChartDarkLightColor
    
    var isShowValueDividingLine: Bool
    
    var dividingValueLineStyle: AxisViewLineStyle
    
    var dividingValueLineColor: LiteChartDarkLightColor
    
    var isShowCoupleDividingLine: Bool
    
    var dividingCoupleLineStyle: AxisViewLineStyle
    
    var dividingCoupleLineColor: LiteChartDarkLightColor

    var isShowValueUnitString: Bool
    
    var isShowCoupleUnitString: Bool
    
    var valueUnitTextColor: LiteChartDarkLightColor
    
    var coupleUnitTextColor: LiteChartDarkLightColor
    
    var valueUnitString: String
    
    var coupleUnitString: String
    
    init(borderStyle: LiteChartViewBorderStyle,
         borderColor: LiteChartDarkLightColor,
         direction: BarChartDirection,
         displayDataMode: ChartValueDisplayMode,
         inputLegendTitles: [String],
         inputDatas: [(LiteChartDarkLightColor, [Double])],
         valueTextColor: LiteChartDarkLightColor,
         coupleTitle: [String],
         coupleTextColor: LiteChartDarkLightColor,
         isShowValueDividingLine: Bool,
         dividingValueLineStyle: AxisViewLineStyle,
         dividingValueLineColor: LiteChartDarkLightColor,
         isShowCoupleDividingLine: Bool,
         dividingCoupleLineStyle: AxisViewLineStyle,
         dividingCoupleLineColor: LiteChartDarkLightColor,
         isShowValueUnitString: Bool,
         isShowCoupleUnitString: Bool,
         valueUnitString: String,
         coupleUnitString: String,
         valueUnitTextColor: LiteChartDarkLightColor,
         coupleUnitTextColor: LiteChartDarkLightColor) {
        self.borderStyle = borderStyle
        self.borderColor = borderColor
        self.direction = direction
        self.displayDataMode = displayDataMode
        self.inputLegendTitles = inputLegendTitles
        self.inputDatas = inputDatas
        
        self.valueTextColor = borderColor
        self.coupleTitle = coupleTitle
        self.coupleTextColor = borderColor
        
        self.isShowValueDividingLine = isShowValueDividingLine
        self.dividingValueLineStyle = dividingValueLineStyle
        self.dividingValueLineColor = dividingValueLineColor
        self.isShowCoupleDividingLine = isShowCoupleDividingLine
        self.dividingCoupleLineColor = dividingCoupleLineColor
        self.dividingCoupleLineStyle = dividingCoupleLineStyle
        
        self.isShowValueUnitString = isShowValueUnitString
        self.isShowCoupleUnitString = isShowCoupleUnitString
        self.valueUnitString = valueUnitString
        self.coupleUnitString = coupleUnitString
        self.valueUnitTextColor = valueUnitTextColor
        self.coupleUnitTextColor = coupleUnitTextColor
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
    
    func computeLegendViews(syncCenterIdentifier: String) -> UIView? {
        guard self.inputDatas.count == self.inputLegendTitles.count else {
            return nil
        }
        var legendViewConfigures: [LegendViewConfigure] = []
        let syncIdentifier = DisplayLabelSyncIdentifier(syncCenterIdentifier: syncCenterIdentifier, syncIdentifierType: .barLegendTitleLabel)
        for index in 0 ..< self.inputDatas.count {
            let legendType = Legend.square
            let displayLabelConfigure = DisplayLabelConfigure(contentString: inputLegendTitles[index], contentColor: self.inputDatas[index].0, textAlignment: .left, syncIdentifier: syncIdentifier)
            let legendConfigure = LegendConfigure(type: legendType, color: self.inputDatas[index].0)
            let legendViewConfigure = LegendViewConfigure(legendConfigure: legendConfigure, contentConfigure: displayLabelConfigure)
            legendViewConfigures.append(legendViewConfigure)
        }
        let legendConfigure = LegendViewsConfigure(models: legendViewConfigures)
        return LegendViews(configure: legendConfigure)
    }
    
    func computeContentView(syncCenterIdentifier: String) -> LiteChartContentView {
        
        guard self.inputDatas.count > 0 else {
            let configure = BarChartViewConfigure.emptyConfigure
            return BarChartView(configure: configure)
        }
        
        let coupleItemCount = self.inputDatas.count
        var coupleDatas: [[Double]] = Array(repeating: [], count: coupleItemCount)
        for index in 0 ..< coupleItemCount {
            coupleDatas[index] = self.inputDatas[index].1
        }
        
        var displayString: [[String]] = Array(repeating: [], count: coupleItemCount)
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
        
        var barViewCoupleConfigures: [BarViewCoupleConfigure] = []
        let coupleCount = inputDatas[0].1.count
        var coupleBarsInputDatas: [[(LiteChartDarkLightColor, CGFloat, String)]] = Array(repeating: [], count: coupleCount)
        
        for inputData in inputDatas {
            for index in 0 ..< coupleCount {
                var coupleBars = coupleBarsInputDatas[index]
                coupleBars.append((inputData.0, inputData.1[index].1, inputData.1[index].0))
                coupleBarsInputDatas[index] = coupleBars
            }
        }
        
        let textAlignment: NSTextAlignment
        switch self.direction {
        case .bottomToTop:
            textAlignment = .center
        case .leftToRight:
            textAlignment = .left
        }
        let barTitleSyncIdentifier = DisplayLabelSyncIdentifier(syncCenterIdentifier: syncCenterIdentifier, syncIdentifierType: .barTitleLabel)
        for coupleBars in coupleBarsInputDatas {
            var barViewsConfigure: [BarViewConfigure] = []
            for input in coupleBars {
                if isShowLabel {
                    let barViewConfigure = BarViewConfigure(length: input.1, barColor: input.0, isShowLabel: true, label: DisplayLabelConfigure(contentString: input.2, contentColor: input.0, textAlignment: textAlignment, syncIdentifier: barTitleSyncIdentifier), direction: self.direction)
                    barViewsConfigure.append(barViewConfigure)
                } else {
                    let barViewConfigure = BarViewConfigure(length: input.1, barColor: input.0, isShowLabel: false, direction: self.direction)
                    barViewsConfigure.append(barViewConfigure)
                }
            }
            let barViewCoupleConfigure = BarViewCoupleConfigure(models: barViewsConfigure, direction: self.direction)
            barViewCoupleConfigures.append(barViewCoupleConfigure)
        }
        
        let unitSyncIdentifier = DisplayLabelSyncIdentifier(syncCenterIdentifier: syncCenterIdentifier, syncIdentifierType: .barUnitTitleLabel)
        var valueUnitStringConfigure = DisplayLabelConfigure(contentString: self.valueUnitString, contentColor: self.valueUnitTextColor, syncIdentifier: unitSyncIdentifier)
        var coupleUnitStringConfigure = DisplayLabelConfigure(contentString: self.coupleUnitString, contentColor: self.coupleUnitTextColor, syncIdentifier: unitSyncIdentifier)
        
        switch self.direction {
        case .bottomToTop:
            let axisConfigure = AxisViewConfigure(originPoint: .zero, axisColor: self.borderColor, verticalDividingPoints: valueDividingLineConfigure, horizontalDividingPoints: coupleDividingLineConfigrue, borderStyle: self.borderStyle.convertToAxisBorderStyle(), borderColor: self.borderColor, isShowXAxis: false, isShowYAxis: false)
            
            valueUnitStringConfigure.textDirection = .vertical
            coupleUnitStringConfigure.textDirection = .horizontal
            
            var coupleTitleConfigures: [DisplayLabelConfigure] = []
            let coupleTitleSyncIdentifier = DisplayLabelSyncIdentifier(syncCenterIdentifier: syncCenterIdentifier, syncIdentifierType: .barCoupleTitleLabel)
            for title in coupleTitles {
                let config = DisplayLabelConfigure(contentString: title, contentColor: self.coupleTextColor, syncIdentifier: coupleTitleSyncIdentifier)
                coupleTitleConfigures.append(config)
            }
            
            var valueTitleConfigures: [DisplayLabelConfigure] = []
            let barValueSyncIdentifier = DisplayLabelSyncIdentifier(syncCenterIdentifier: syncCenterIdentifier, syncIdentifierType: .barValueTitleLabel)
            for title in valuesString {
                let config = DisplayLabelConfigure(contentString: title, contentColor: self.valueTextColor, textAlignment: .right, syncIdentifier: barValueSyncIdentifier)
                valueTitleConfigures.append(config)
            }
            
            let barViewCoupleCollectionConfigure = BarViewCoupleCollectionConfigure(models: barViewCoupleConfigures, direction: self.direction)
            let barChartViewConfigure = BarChartViewConfigure(direction: self.direction, isShowValueUnitString: self.isShowValueUnitString, isShowCoupleUnitString: self.isShowCoupleUnitString, axisConfigure: axisConfigure, valueUnitStringConfigure: valueUnitStringConfigure, coupleUnitStringConfigure: coupleUnitStringConfigure, coupleTitleConfigure: coupleTitleConfigures, valueTitleConfigure: valueTitleConfigures, barViewCoupleCollectionConfigure: barViewCoupleCollectionConfigure)
            return BarChartView(configure: barChartViewConfigure)
        case .leftToRight:
            let axisConfigure = AxisViewConfigure(originPoint: .zero, axisColor: self.borderColor, verticalDividingPoints: coupleDividingLineConfigrue, horizontalDividingPoints: valueDividingLineConfigure, borderStyle: self.borderStyle.convertToAxisBorderStyle(), borderColor: self.borderColor, isShowXAxis: false, isShowYAxis: false)
            
            valueUnitStringConfigure.textDirection = .horizontal
            coupleUnitStringConfigure.textDirection = .vertical
            
            var coupleTitleConfigures: [DisplayLabelConfigure] = []
            let coupleTitleSyncIdentifier = DisplayLabelSyncIdentifier(syncCenterIdentifier: syncCenterIdentifier, syncIdentifierType: .barCoupleTitleLabel)
            for title in coupleTitles {
                let config = DisplayLabelConfigure(contentString: title, contentColor: self.coupleTextColor, textAlignment: .right, syncIdentifier: coupleTitleSyncIdentifier)
                coupleTitleConfigures.append(config)
            }
            
            var valueTitleConfigures: [DisplayLabelConfigure] = []
            let barValueSyncIdentifier = DisplayLabelSyncIdentifier(syncCenterIdentifier: syncCenterIdentifier, syncIdentifierType: .barValueTitleLabel)
            for title in valuesString {
                let config = DisplayLabelConfigure(contentString: title, contentColor: self.valueTextColor, syncIdentifier: barValueSyncIdentifier)
                valueTitleConfigures.append(config)
            }
            
            let barViewCoupleCollectionConfigure = BarViewCoupleCollectionConfigure(models: barViewCoupleConfigures, direction: self.direction)
            
            let barChartViewConfigure = BarChartViewConfigure(direction: self.direction, isShowValueUnitString: self.isShowValueUnitString, isShowCoupleUnitString: self.isShowCoupleUnitString, axisConfigure: axisConfigure, valueUnitStringConfigure: valueUnitStringConfigure, coupleUnitStringConfigure: coupleUnitStringConfigure, coupleTitleConfigure: coupleTitleConfigures, valueTitleConfigure: valueTitleConfigures, barViewCoupleCollectionConfigure: barViewCoupleCollectionConfigure)
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
