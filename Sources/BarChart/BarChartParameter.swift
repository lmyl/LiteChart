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
    
    var inputLegendTitles: [String]?
    
    var displayDataMode: ChartValueDisplayMode
    
    var dividingLineStyle: AxisViewLlineStyle
    
    var dividingLineColor: LiteChartDarkLightColor
    
    var numOfDividingLine: Int
    
    init(borderStyle: BarChartViewBorderStyle, borderColor: LiteChartDarkLightColor, direction: BarChartDirection, textColor: LiteChartDarkLightColor, inputDatas: [(LiteChartDarkLightColor, [Double])], coupleTitle: [String], displayDataMode: ChartValueDisplayMode, dividingLineStyle: AxisViewLlineStyle, dividingLineColor: LiteChartDarkLightColor, numOfDividingLine: Int, inputLegendTitles: [String]?) {
        self.borderStyle = borderStyle
        self.borderColor = borderColor
        self.direction = direction
        self.textColor = textColor
        self.inputDatas = inputDatas
        self.coupleTitle = coupleTitle
        self.displayDataMode = displayDataMode
        self.dividingLineStyle = dividingLineStyle
        self.dividingLineColor = dividingLineColor
        self.numOfDividingLine = numOfDividingLine
        self.inputLegendTitles = inputLegendTitles
    }
    
}

extension BarChartParameter: LiteChartParametersProcesser {
    func checkInputDatasParameterInvalid() throws {
        let inputDatas = self.inputDatas
        if inputDatas.count > 0 {
            let firstDataCount = inputDatas[0].1.count
            if firstDataCount != self.coupleTitle.count {
                throw ChartError.inputDatasNotMatched
            }
            for inputData in inputDatas {
                if inputData.1.count != firstDataCount {
                    throw ChartError.inputDatasNotMatched
                }
                let filter = inputData.1.filter{
                    $0 < 0
                }
                if !filter.isEmpty {
                    throw ChartError.inputDatasMustPositive
                }
            }
        } else {
            return
        }
    }
    
    func computeLegendViewConfigure() -> LegendViewsConfigure? {
        guard let inputLegendTitles = self.inputLegendTitles, self.inputDatas.count == self.inputLegendTitles?.count else {
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
            let configure = BarChartViewConfigure()
            return BarChartView(configure: configure)
        }
        
        let coupleCount = self.inputDatas.count
        var coupleDatas: [[Double]] = Array(repeating: [], count: coupleCount)
        for index in 0 ..< coupleCount { 
            coupleDatas[index] = self.inputDatas[index].1
        }
        
        var displayString: [[String]] = Array(repeating: [], count: coupleCount)
        switch self.displayDataMode {
        case .original, .mix, .percent:
            displayString = self.computeOriginalString(for: coupleDatas)
        case .none:
            displayString = []
        }
        
        var inputDatas: [(LiteChartDarkLightColor, [(String?, CGFloat)])] = []
        let proportionalValue = self.computeProportionalValue(for: coupleDatas)
        
        for index in 0 ..< self.inputDatas.count {
            var datas: [(String?, CGFloat)] = []
            for innerIndex in 0 ..< self.inputDatas[index].1.count {
                if self.displayDataMode != .none{
                    let string = displayString[index][innerIndex]
                    datas.append((string, CGFloat(proportionalValue[index][innerIndex])))
                } else {
                    datas.append((nil, CGFloat(proportionalValue[index][innerIndex])))
                }
            }
            inputDatas.append((self.inputDatas[index].0, datas))
        }
        if inputDatas.count >= 2 {
            let firstDataCount = inputDatas[0].1.count
            for inputData in inputDatas {
                if inputData.1.count != firstDataCount {
                    fatalError("框架内部数据处理错误，不给予拯救!")
                }
            }
        }
        
        let lineCount = self.numOfDividingLine
        var axisDividingLineConfigures: [AxisDividingLineConfigure] = []
        var valueTitles: [String] = []
        if lineCount == 0 {
            
        }else {
            var positions: [Double] = Array(repeating: 0.75, count: lineCount)
            for (index, num) in positions.enumerated() {
                positions[index] = num / Double(lineCount + 1) * Double(index + 1)
            }
            valueTitles = self.computeValueTitleString(positions, coupleDatas)
            for index in 0 ..< self.numOfDividingLine {
                let axisDividingLineConfigure = AxisDividingLineConfigure(dividingLineStyle: self.dividingLineStyle, dividingLineColor: self.dividingLineColor, location: CGFloat(positions[index]))
                axisDividingLineConfigures.append(axisDividingLineConfigure)
            }
        }
        
        guard valueTitles.count == self.numOfDividingLine else {
            fatalError("框架内部数据处理错误，不给予拯救!")
        }
        
        switch self.direction {
        case .bottomToTop:
            let barChartViewConfigure = BarChartViewConfigure(textColor: textColor, coupleTitle: self.coupleTitle, valueTitle: valueTitles, inputDatas: inputDatas, direction: .bottomToTop, borderColor: self.borderColor, borderStyle: self.borderStyle, xDividingPoints: [], yDividingPoints: axisDividingLineConfigures)
            return BarChartView(configure: barChartViewConfigure)
        case .leftToRight:
            let barChartViewConfigure = BarChartViewConfigure(textColor: textColor, coupleTitle: self.coupleTitle, valueTitle: valueTitles, inputDatas: inputDatas, direction: .leftToRight, borderColor: self.borderColor, borderStyle: self.borderStyle, xDividingPoints: axisDividingLineConfigures, yDividingPoints: [])
            return BarChartView(configure: barChartViewConfigure)
        }
        
    }
    
    private func computeDividingPointValue(_ positions: [Double], _ datas: [[Double]]) -> [Double] {
        var maxData:Double = 0
        for coupleDatas in datas {
            let curMax = coupleDatas.max()
            maxData = max(maxData, curMax!)
        }
        return positions.map{ $0 * maxData / 0.75}
    }
    
    private func computeOriginalValue(for datas: [[Double]]) -> [[Double]] {
        return self.inputDatas.map{
            $0.1
        }
    }
    
    private func computeProportionalValue(for datas: [[Double]]) -> [[Double]] {
        var maxData:Double = 0
        for coupleDatas in datas {
            let curMax = coupleDatas.max()
            maxData = max(maxData, curMax!)
        }
        return self.inputDatas.map{
            $0.1.map{
                $0 / maxData * 0.75
            }
        }
    }
    
    private var displayOriginalFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.positiveFormat = ",###.##"
        return formatter
    }
    
    private var displayValueTitleFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.positiveFormat = ",###"
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
    
    private func computeValueTitleString(_ positions: [Double], _ datas: [[Double]]) -> [String] {
        let formatter = self.displayValueTitleFormatter
        return self.computeDividingPointValue(positions, datas).map {
            let nsNumber = $0 as NSNumber
            return formatter.string(from: nsNumber) ?? "Data Error !"
        }
    }
    
}
