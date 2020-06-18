//
//  LineChartParameters.swift
//  LiteChart
//
//  Created by huangxiaohui on 2020/6/17.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit

struct LineChartParameters {
    
    var borderStyle: BarChartViewBorderStyle
    
    var borderColor: LiteChartDarkLightColor
    
    var textColor: LiteChartDarkLightColor
    
    var inputDatas: [(LiteChartDarkLightColor, LineStyle, Legend , [Double])]
    
    var coupleTitles: [String]
    
    var inputLegendTitles: [String]? // 图例显示
    
    var legendType: Legend // 图例显示的类型
    
    var displayDataMode: ChartValueDisplayMode
    
    var dividingValueLineStyle: AxisViewLineStyle
    
    var dividingValueLineColor: LiteChartDarkLightColor
    
    var dividingCoupleLineStyle: AxisViewLineStyle
    
    var dividingCoupleLineColor: LiteChartDarkLightColor
    
    var isShowValueDividingLine: Bool
    
    var isShowCoupleDividingLine: Bool
    
    var valueUnitString: String?
    
    var coupleUnitString: String?
    
    var axisColor: LiteChartDarkLightColor
    
    init(borderStyle: BarChartViewBorderStyle, borderColor: LiteChartDarkLightColor, textColor: LiteChartDarkLightColor, inputDatas: [(LiteChartDarkLightColor, LineStyle, Legend , [Double])], coupleTitles: [String], inputLegendTitles: [String]?, legendType: Legend, displayDataMode: ChartValueDisplayMode, dividingValueLineStyle: AxisViewLineStyle, dividingValueLineColor: LiteChartDarkLightColor, dividingCoupleLineStyle: AxisViewLineStyle, dividingCoupleLineColor: LiteChartDarkLightColor, isShowValueDividingLine: Bool, isShowCoupleDividingLine: Bool, valueUnitString: String?, coupleUnitString: String?, axisColor: LiteChartDarkLightColor) {
        self.borderStyle = borderStyle
        self.borderColor = borderColor
        self.inputDatas = inputDatas
        self.textColor = textColor
        self.coupleTitles = coupleTitles
        self.inputLegendTitles = inputLegendTitles
        self.legendType = legendType
        self.displayDataMode = displayDataMode
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

extension LineChartParameters: LiteChartParametersProcesser {
    func checkInputDatasParameterInvalid() throws {
        let inputDatas = self.inputDatas
        if inputDatas.count > 0 {
            let firstDataCount = inputDatas[0].3.count
            if firstDataCount != self.coupleTitles.count {
                throw ChartError.inputDatasNumberMustEqualForCouple
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
        guard let inputLegendTitles = self.inputLegendTitles, inputLegendTitles.count == self.inputDatas.count else {
            return nil
        }
        var legendViewConfigures: [LegendViewConfigure] = []
        for index in 0 ..< self.inputDatas.count {
            let legendType = self.legendType
            let displayLabelConfigure = DisplayLabelConfigure(contentString: inputLegendTitles[index], contentColor: textColor, textAlignment: .left)
            let legendConfigure = LegendConfigure(color: self.inputDatas[index].0)
            let legendViewConfigure = LegendViewConfigure(legendType: legendType, legendConfigure: legendConfigure, contentConfigure: displayLabelConfigure)
            legendViewConfigures.append(legendViewConfigure)
            
        }
        return LegendViewsConfigure(models: legendViewConfigures)
    }

    func computeContentView() -> UIView {
        guard self.inputDatas.count > 0 else {
            let configure = LineChartViewConfigure()
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
        
        var inputDatas: [(LiteChartDarkLightColor, LineStyle, Legend , [(String?, CGPoint)])] = []
        let valueForAxis = self.positiveAndNegativeValueForAxis(input: coupleDatas)
        
        let proportionY = self.computeProportionalValue(for: coupleDatas, axisValue: valueForAxis.axisValue)
        guard let firstValueCount = self.inputDatas.first?.3.count else {
            fatalError("内部数据处理错误，不给予拯救")
        }
        var proportionX: [Double] = []
        for index in 1 ... firstValueCount {
            proportionX.append(1 / Double(firstValueCount + 1) * Double(index))
        }
        for index in 0 ..< self.inputDatas.count {
            var datas: [(String?, CGPoint)] = []
            for innerIndex in 0 ..< firstValueCount {
                if self.displayDataMode == .original {
                    let string = displayString[index][innerIndex]
                    datas.append((string, CGPoint(x: proportionX[innerIndex], y: proportionY[index][innerIndex])))
                } else {
                    datas.append((nil, CGPoint(x: proportionX[innerIndex], y: proportionY[index][innerIndex])))
                }
            }
            inputDatas.append((self.inputDatas[index].0, self.inputDatas[index].1, self.inputDatas[index].2, datas))
        }
        
        var valuesString: [String] = []
        var valueDividingLineConfigure: [AxisDividingLineConfigure] = []
        if self.isShowValueDividingLine {
            let dividingPoints = valueForAxis.dividingPoints
            let dividingValue = self.computeProportionalValue(for: dividingPoints, axisValue: valueForAxis.axisValue)
            valuesString = self.computeValueTitleString(dividingPoints)
            for value in dividingValue {
                let configure = AxisDividingLineConfigure(dividingLineStyle: self.dividingValueLineStyle, dividingLineColor: self.dividingValueLineColor, location: CGFloat(value))
                valueDividingLineConfigure.append(configure)
            }
        }
        
        var coupleDividingLineConfigure: [AxisDividingLineConfigure] = []
        if self.isShowCoupleDividingLine && firstValueCount >= 2 {
            for value in proportionX {
                let configure = AxisDividingLineConfigure(dividingLineStyle: self.dividingCoupleLineStyle, dividingLineColor: self.dividingCoupleLineColor, location: CGFloat(value))
                coupleDividingLineConfigure.append(configure)
            }
        }
        
        let axisOriginal = self.computeOriginalValueForAxis(valueForAxis.axisValue)
        let lineChartViewConfigure = LineChartViewConfigure(textColor: self.textColor, coupleTitle: self.coupleTitles, valueTitle: valuesString, inputDatas: inputDatas, borderColor: self.borderColor, borderStyle: self.borderStyle, axisOriginal: axisOriginal, axisColor: self.axisColor, xDividingPoints: coupleDividingLineConfigure, yDividingPoints: valueDividingLineConfigure, valueUnitString: self.valueUnitString, coupleUnitString: self.coupleUnitString)
        return LineChartView(configure: lineChartViewConfigure)
    }
    
    
    private func positiveAndNegativeValueForAxis(input datas: [[Double]]) -> (axisValue: (Double, Double), dividingPoints: [Double]) {
        var maxValue: Double = -1
        var minValue: Double = 1
        for data in datas {
            let maxCur = data.max()
            let minCur = data.min()
            if let maximum = maxCur, let minimum = minCur {
                maxValue = max(maximum, maxValue)
                minValue = min(minimum, minValue)
            }
        }
        if minValue <= 0 {
            minValue = -minValue // 输出负数表示数据无效
        } else {
            minValue = -1
        }
        maxValue = maxValue / 0.75
        minValue = minValue / 0.75
        return self.caculateValueAndDividingPointForAxis(input: (maxValue, minValue))
    }
    
    private func computeOriginalValueForAxis(_ input: (Double, Double)) -> CGPoint {
        if input.0 == 0 && input.1 == 0 {
            return CGPoint.zero
        }
        let yOffset = input.1 / (input.0 + input.1)
        return CGPoint(x: 0, y: yOffset)
        
    }
    
    private func computeOriginalValue(for datas: [[Double]]) -> [[Double]] {
        return datas
    }
    
    private func computeProportionalValue(for datas: [[Double]], axisValue: (Double, Double)) -> [[Double]] {
        let sumValue = axisValue.0 + axisValue.1
        print("sumvalue = \(sumValue)")
        return datas.map{
            $0.map{
                ($0 + axisValue.1) / sumValue
            }
        }
    }
    
    private func computeProportionalValue(for datas: [Double], axisValue: (Double, Double)) -> [Double] {
        
        let sumValue = axisValue.0 + axisValue.1
        print("sumValue2 = \(sumValue)")
        return datas.map{
            ($0 + axisValue.1) / sumValue
        }
    }
    
    private func caculateValueAndDividingPointForAxis(input data: (Double, Double)) -> (axisValue: (Double, Double), dividingPoints: [Double]) {
        print("input data is \(data)")
        // 判断0
        var tempData = data
        if data.0 == 0 {
            tempData.0 = 1
        }
        if data.1 == 0 {
            tempData.1 = 1
        }
        if data.0 < 0 {
            tempData.0 = 0
        }
        if data.1 < 0 {
            tempData.1 = 0
        }
        let inputData = max(tempData.0, tempData.1)
        var positiveLarger = false
        if tempData.0 >= tempData.1 {
            positiveLarger = true
        }
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
        var dividingPoints = [Double]()
        let dividingInterval = value / Double(dividingPart)
        if positiveLarger {
            var negativerRemainder = tempData.1
            var count = 0
            while negativerRemainder > 0 {
                negativerRemainder -= dividingInterval
                count += 1
            }
            
            for index in (0 ... count).reversed() {
                if index == 0 {
                    dividingPoints.append(0)
                } else {
                    dividingPoints.append(-Double(index) * dividingInterval)
                }
            }
            for index in 1 ... dividingPart {
                dividingPoints.append(Double(index) * dividingInterval)
            }
        } else {
            var posotiveRemainder = tempData.0
            var count = 0
            while posotiveRemainder > 0 {
                posotiveRemainder -= dividingInterval
                count += 1
            }
            for index in (1 ... dividingPart).reversed() {
                dividingPoints.append(-Double(index) * dividingInterval)
            }
            for index in 0 ... count {
                dividingPoints.append(Double(index) * dividingInterval)
            }
        }
        var min:Double = 0
        var max:Double = 0
        if let minTemp = dividingPoints.first, let maxTemp = dividingPoints.last {
            min = abs(minTemp)
            max = maxTemp
        }
        dividingPoints.removeLast()
        dividingPoints.removeFirst()
        return ((max, min), dividingPoints)
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
        print(datasString)
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
