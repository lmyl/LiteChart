//
//  LineChartParameters.swift
//  LiteChart
//
//  Created by huangxiaohui on 2020/6/17.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit

struct LineChartParameters {
    
    var borderStyle: LiteChartViewBorderStyle
    
    var borderColor: LiteChartDarkLightColor
    
    var displayDataMode: ChartValueDisplayMode
    
    var inputLegendTitles: [String] // 图例显示
    
    var inputDatas: [(LiteChartDarkLightColor, LineStyle, Legend , [Double])]
    
    var valueTextColor: LiteChartDarkLightColor
    
    var coupleTitles: [String]
    
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
         displayDataMode: ChartValueDisplayMode,
         inputLegendTitles: [String],
         inputDatas: [(LiteChartDarkLightColor, LineStyle, Legend , [Double])],
         valueTextColor: LiteChartDarkLightColor,
         coupleTitles: [String],
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
        self.displayDataMode = displayDataMode
        self.inputLegendTitles = inputLegendTitles
        self.inputDatas = inputDatas
        self.valueTextColor = valueTextColor
        self.coupleTitles = coupleTitles
        self.coupleTextColor = coupleTextColor
        self.isShowValueDividingLine = isShowValueDividingLine
        self.dividingValueLineColor = dividingValueLineColor
        self.dividingValueLineStyle = dividingValueLineStyle
        self.isShowCoupleDividingLine = isShowCoupleDividingLine
        self.dividingCoupleLineColor = dividingCoupleLineColor
        self.dividingCoupleLineStyle = dividingCoupleLineStyle
        self.isShowCoupleUnitString = isShowCoupleUnitString
        self.valueUnitString = valueUnitString
        self.valueUnitTextColor = valueUnitTextColor
        self.isShowValueUnitString = isShowValueUnitString
        self.coupleUnitString = coupleUnitString
        self.coupleUnitTextColor = coupleUnitTextColor
        self.axisColor = axisColor
        self.isShowAxis = isShowAxis
    }
}

extension LineChartParameters: LiteChartParametersProcesser {
    func checkInputDatasParameterInvalid() throws {
        let inputDatas = self.inputDatas
        if inputDatas.count > 0 {
            let firstDataCount = inputDatas[0].3.count
            if firstDataCount != self.coupleTitles.count {
                throw ChartError.inputDatasNumbersNotMatchedCoupleTitle
            }
            for inputData in inputDatas {
                if inputData.3.count != firstDataCount {
                    throw ChartError.inputDatasNumberMustEqualForCouple
                }
            }
        } else {
            return
        }
    }

    func computeLegendViewConfigure() -> LegendViewsConfigure? {
        guard self.inputLegendTitles.count == self.inputDatas.count else {
            return nil
        }
        var legendViewConfigures: [LegendViewConfigure] = []
        for index in 0 ..< self.inputDatas.count {
            let legendType = self.inputDatas[index].2
            let displayLabelConfigure = DisplayLabelConfigure(contentString: inputLegendTitles[index], contentColor: self.inputDatas[index].0, textAlignment: .left, syncIdentifier: .lineLegendTitleLabel)
            let legendConfigure = LegendConfigure(type: legendType, color: self.inputDatas[index].0)
            let legendViewConfigure = LegendViewConfigure(legendConfigure: legendConfigure, contentConfigure: displayLabelConfigure)
            legendViewConfigures.append(legendViewConfigure)
            
        }
        return LegendViewsConfigure(models: legendViewConfigures)
    }

    func computeContentView() -> LiteChartContentView {
        guard self.inputDatas.count > 0 else {
            let configure = LineChartViewConfigure.emptyConfigure
            return LineChartView(configure: configure)
        }
        let coupleCount = self.inputDatas.count
        var coupleDatas: [[Double]] = Array(repeating: [], count: coupleCount)
        for index in 0 ..< coupleCount {
            coupleDatas[index] = self.inputDatas[index].3
        }
        var displayString: [[String]] = Array(repeating: [], count: coupleCount)
        switch self.displayDataMode {
        case .original:
            displayString = self.computeOriginalString(for: coupleDatas)
        case .mix, .none, .percent:
            displayString = []
        }
        
        var inputDatas: [(LiteChartDarkLightColor, LineStyle, Legend , [(String, CGPoint)])] = []
        let valueForAxis = self.positiveAndNegativeValueForAxis(input: coupleDatas)
        
        let proportionY = self.computeProportionalValue(for: coupleDatas, axisValue: valueForAxis.axisValue)
        guard let firstValueCount = self.inputDatas.first?.3.count else {
            fatalError("内部数据处理错误，不给予拯救")
        }
        var proportionX: [Double] = []
        for index in 0 ..< firstValueCount {
            proportionX.append(1 / Double(firstValueCount + 1) * Double(index + 1))
        }
        for index in 0 ..< self.inputDatas.count {
            var datas: [(String, CGPoint)] = []
            for innerIndex in 0 ..< firstValueCount {
                if self.displayDataMode == .original {
                    let string = displayString[index][innerIndex]
                    datas.append((string, CGPoint(x: proportionX[innerIndex], y: proportionY[index][innerIndex])))
                } else {
                    datas.append(("", CGPoint(x: proportionX[innerIndex], y: proportionY[index][innerIndex])))
                }
            }
            inputDatas.append((self.inputDatas[index].0, self.inputDatas[index].1, self.inputDatas[index].2, datas))
        }
        
        var valuesString: [String] = []
        var valueDividingLineConfigure: [AxisDividingLineConfigure] = []
        
        if self.isShowValueDividingLine {
            let dividingPoints = valueForAxis.dividingPoints
            valuesString = self.computeValueTitleString(dividingPoints)
            let dividingValue = self.computeProportionalValue(for: dividingPoints, axisValue: valueForAxis.axisValue)
            for value in dividingValue {
                let configure = AxisDividingLineConfigure(dividingLineStyle: self.dividingValueLineStyle, dividingLineColor: self.dividingValueLineColor, location: CGFloat(value))
                valueDividingLineConfigure.append(configure)
            }
        }
        
        var coupleTitleString: [String] = []
        var coupleDividingLineConfigure: [AxisDividingLineConfigure] = []
        if self.isShowCoupleDividingLine {
            coupleTitleString = self.coupleTitles
            for value in proportionX {
                let configure = AxisDividingLineConfigure(dividingLineStyle: self.dividingCoupleLineStyle, dividingLineColor: self.dividingCoupleLineColor, location: CGFloat(value))
                coupleDividingLineConfigure.append(configure)
            }
        }
        
        let axisOriginal = self.computeOriginalValueForAxis(valueForAxis.axisValue)
        let isShowLabel = self.displayDataMode == .original
        
        let valueUnitStringConfigure = DisplayLabelConfigure(contentString: self.valueUnitString, contentColor: self.valueUnitTextColor, textAlignment: .center, textDirection: .vertical, syncIdentifier: .lineUnitTitleLabel)
        let coupleUnitStringConfigure = DisplayLabelConfigure(contentString: self.coupleUnitString, contentColor: self.coupleUnitTextColor, textAlignment: .center, textDirection: .horizontal, syncIdentifier: .lineUnitTitleLabel)
        
        var coupleTitleConfigures: [DisplayLabelConfigure] = []
        for title in coupleTitleString {
            let configure = DisplayLabelConfigure(contentString: title, contentColor: self.coupleTextColor, syncIdentifier: .lineCoupleTitleLabel)
            coupleTitleConfigures.append(configure)
        }
        
        var valueTitleConfigures: [DisplayLabelConfigure] = []
        for title in valuesString {
            let configure = DisplayLabelConfigure(contentString: title, contentColor: self.valueTextColor, textAlignment: .right, syncIdentifier: .lineValueTitleLabel)
            valueTitleConfigures.append(configure)
        }
        
        let borderStlye = self.borderStyle.convertToAxisBorderStyle()
        let axisConfigure = AxisViewConfigure(originPoint: axisOriginal, axisColor: self.axisColor, verticalDividingPoints: valueDividingLineConfigure, horizontalDividingPoints: coupleDividingLineConfigure, borderStyle: borderStlye, borderColor: self.borderColor, isShowXAxis: self.isShowAxis, isShowYAxis: false)
        
        var lineConfigures: [LineViewConfigure] = []
        var lineValueViewPoints: [[CGPoint]] = []
        var lineValueViewLabel: [[DisplayLabelConfigure]] = []
        for inputData in inputDatas {
            let titleStringConfigure = inputData.3.map{
                DisplayLabelConfigure(contentString: $0.0, contentColor: inputData.0, syncIdentifier: .lineTitleLabel)
            }
            let points = inputData.3.map{
                $0.1
            }
            lineValueViewPoints.append(points)
            lineValueViewLabel.append(titleStringConfigure)
            let lineConfigure = LineViewConfigure(points: points, legendConfigure: .init(type: inputData.2, color: inputData.0), lineStyle: inputData.1, lineColor: inputData.0)
            lineConfigures.append(lineConfigure)
        }
        
        let lineValueViewConfigure = LineValueViewConfigure(points: lineValueViewPoints, labelConfigure: lineValueViewLabel)
        let lineViewsConfigure = LineViewsConfigure(models: lineConfigures, valueModel: lineValueViewConfigure, isShowLabel: isShowLabel)
        let lineChartConfigure = LineChartViewConfigure(isShowValueUnitString: self.isShowValueUnitString, isShowCoupleUnitString: self.isShowCoupleUnitString, axisConfigure: axisConfigure, valueUnitStringConfigure: valueUnitStringConfigure, coupleUnitStringConfigure: coupleUnitStringConfigure, coupleTitleConfigure: coupleTitleConfigures, valueTitleConfigure: valueTitleConfigures, lineViewsConfigure: lineViewsConfigure)
        return LineChartView(configure: lineChartConfigure)
    }
    
    
    private func positiveAndNegativeValueForAxis(input datas: [[Double]]) -> (axisValue: (Double, Double), dividingPoints: [Double]) {
        
        var maxValue: Double
        var minValue: Double
        
        if datas.isEmpty {
            fatalError("内部数据处理错误，不给予拯救")
        } else if !datas.isEmpty && datas[0].isEmpty {
            maxValue = 0
            minValue = 0
        } else {
            maxValue = datas[0][0]
            minValue = maxValue
            for data in datas {
                let maxCur = data.max()
                let minCur = data.min()
                if let maximum = maxCur, let minimum = minCur {
                    maxValue = max(maximum, maxValue)
                    minValue = min(minimum, minValue)
                }
            }
        }
        
        maxValue = maxValue / 0.75
        minValue = minValue / 0.75
        
        return self.caculateValueAndDividingPointForAxis(input: (maxValue, minValue))
    }
    
    private func computeOriginalValueForAxis(_ input: (maxValue: Double, minValue: Double)) -> CGPoint {
        if input.minValue > 0 {
            return CGPoint.zero
        } else if input.maxValue < 0 {
            return CGPoint(x: 0, y: 1)
        } else {
            let sumValue = input.maxValue + abs(input.minValue)
            let yOffset = abs(input.minValue) / sumValue
            return CGPoint(x: 0, y: yOffset)
        }
    }
    
    private func computeOriginalValue(for datas: [[Double]]) -> [[Double]] {
        return datas
    }
    
    private func computeProportionalValue(for datas: [[Double]], axisValue: (maxValue: Double, minValue: Double)) -> [[Double]] {
        if axisValue.minValue > 0 { // 均为正数
            let sumValue = axisValue.maxValue
            return datas.map{
                $0.map{
                    $0 / sumValue
                }
            }
        } else if axisValue.maxValue < 0 { // 均为负数
            let sumValue = abs(axisValue.minValue)
            return datas.map{
                $0.map{
                    (sumValue + $0) / sumValue
                }
            }
        } else { // 有正有负
            let sumValue = axisValue.maxValue + abs(axisValue.minValue)
            return datas.map{
                $0.map{
                    ($0 + abs(axisValue.minValue)) / sumValue
                }
            }
        }
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
}
