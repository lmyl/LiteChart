//
//  FunalChartParameters.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/7.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit

struct FunalChartParameters {
    
    var valueTextColor: LiteChartDarkLightColor
    
    var inputDatas: [(Double, LiteChartDarkLightColor)]
    
    var inputLegendTitles: [String]
    
    var displayDataMode: ChartValueDisplayMode
    
    init(inputDatas: [(Double, LiteChartDarkLightColor)], inputLegendTitles: [String], displayDataMode: ChartValueDisplayMode, valueTextColor: LiteChartDarkLightColor) {
        self.inputDatas = inputDatas
        self.inputLegendTitles = inputLegendTitles
        self.displayDataMode = displayDataMode
        self.valueTextColor = valueTextColor
    }
    
}

extension FunalChartParameters: LiteChartParametersProcesser {
    
    func checkInputDatasParameterInvalid() throws {
        for index in 0 ..< self.inputDatas.count {
            if self.inputDatas[index].0 <= 0 {
                throw ChartError.inputDatasMustPositive
            }
            if index == 0 {
                continue
            } else if self.inputDatas[index].0 <= self.inputDatas[index - 1].0 {
                continue
            } else {
                throw ChartError.inputDatasNotTrueSorted
            }
        }
    }
    
    func computeLegendViews() -> UIView? {
        guard self.inputDatas.count == inputLegendTitles.count else {
            return nil
        }
        var legendViewConfigures: [LegendViewConfigure] = []
        
        for index in 0 ..< self.inputDatas.count {
            let legendType = Legend.square
            let displayLabelConfigure = DisplayLabelConfigure(contentString: inputLegendTitles[index], contentColor: self.inputDatas[index].1, textAlignment: .left, syncIdentifier: .funalLegendTitleLabel)
            let legendConfigure = LegendConfigure(type: legendType, color: self.inputDatas[index].1)
            let legendViewConfigure = LegendViewConfigure(legendConfigure: legendConfigure, contentConfigure: displayLabelConfigure)
            legendViewConfigures.append(legendViewConfigure)
        }
        
        let legendConfigure = LegendViewsConfigure(models: legendViewConfigures)
        return LegendViews(configure: legendConfigure)
    }
    
    func computeContentView() -> LiteChartContentView {
        
        guard self.inputDatas.count > 0 else {
            let configure = FunalViewConfigure.emptyconfigure
            return FunalView(configure: configure)
        }
        
        let datas = self.inputDatas.map{
            $0.0
        }
        
        var percents = self.computePercentValue(for: datas)
        percents.append(0)
        var inputPercents: [(Double, Double)] = []
        for index in 1 ..< percents.count {
            inputPercents.append((percents[index - 1], percents[index]))
        }
        
        var displayString: [String] = []
        switch self.displayDataMode {
        case .original:
            displayString = self.computeOriginalString(for: datas)
        case .percent:
            displayString = self.computePercentString(for: datas)
        case .mix:
            displayString = self.computeMixString(for: datas)
        case .none:
            displayString = []
        }
        
        var funalViewConfigure: [FunalFloorViewConfigure] = []
        
        guard inputPercents.count == self.inputDatas.count else {
            fatalError("此为框架内部处理数据不当产生的bug，不给予拯救!")
        }
        
        if self.displayDataMode != .none && displayString.count != self.inputDatas.count {
            fatalError("此为框架内部处理数据不当产生的bug，不给予拯救!")
        }
        
        for index in 0 ..< self.inputDatas.count {
            let backgroundViewConfigure = FunalFloorBackagroundViewConfigure(color: self.inputDatas[index].1, topPercent: CGFloat(inputPercents[index].0), bottomPercent: CGFloat(inputPercents[index].1))
            
            if self.displayDataMode == .none {
                let funalFloorConfigure = FunalFloorViewConfigure(backgroundViewConfigure: backgroundViewConfigure, isShowLabel: false)
                funalViewConfigure.append(funalFloorConfigure)
            } else {
                let contentViewConfigure = DisplayLabelConfigure(contentString: displayString[index], contentColor: valueTextColor, textAlignment: .center, syncIdentifier: .funalTitleLabel)
                let funalFloorConfigure = FunalFloorViewConfigure(backgroundViewConfigure: backgroundViewConfigure, isShowLabel: true, contentViewConfigure: contentViewConfigure)
                funalViewConfigure.append(funalFloorConfigure)
            }
        }
        
        let configure = FunalViewConfigure(models: funalViewConfigure)
        return FunalView(configure: configure)
        
    }
    
    private func computePercentValue(for datas: [Double]) -> [Double] {
        guard let first = datas.first else {
            return []
        }
        return datas.map{
            $0 / first
        }
    }
    
    private func computeOriginalValue(for datas: [Double]) -> [Double] {
        return datas
    }
    
    private func computeMixValue(for datas: [Double]) -> [(original: Double, percent: Double)] {
        let original = self.computeOriginalValue(for: datas)
        let percent = self.computePercentValue(for: datas)
        guard original.count == percent.count else {
            fatalError("此为框架内部处理数据不当产生的bug，不给予拯救!")
        }
        var mix: [(Double, Double)] = []
        for index in 0 ..< original.count {
            mix.append((original[index], percent[index]))
        }
        return mix
    }
    
    private var displayOriginalFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.positiveFormat = ",###.##"
        return formatter
    }
    
    private var displayPercentFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.positiveFormat = "0.00%"
        return formatter
    }
    
    private func computeOriginalString(for datas: [Double]) -> [String] {
        let formatter = self.displayOriginalFormatter
        return self.computeOriginalValue(for: datas).map{
            let nsNumber = $0 as NSNumber
            return formatter.string(from: nsNumber) ?? "Data Error!"
        }
    }
    
    private func computePercentString(for datas: [Double]) -> [String] {
        let formatter = self.displayPercentFormatter
        return self.computePercentValue(for: datas).map{
            let nsNumber = $0 as NSNumber
            return formatter.string(from: nsNumber) ?? "Data Error!"
        }
    }
    
    private func computeMixString(for datas: [Double]) -> [String] {
        let originalString = self.computeOriginalString(for: datas)
        let percentString = self.computePercentString(for: datas)
        guard originalString.count == percentString.count else {
            fatalError("此为框架内部处理数据不当产生的bug，不给予拯救!")
        }
        var mix: [String] = []
        for index in 0 ..< originalString.count {
            let result = originalString[index] + "(" + percentString[index] + ")"
            mix.append(result)
        }
        return mix
    }
}


