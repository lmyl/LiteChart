//
//  FunalChartParameters.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/7.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation
import CoreGraphics

struct FunalChartParameters {
    var titleString: String?
    
    var textColor: LiteChartDarkLightColor = .init(lightColor: .black, darkColor: .white)
    
    var inputDatas: [(Double, LiteChartDarkLightColor)]
    
    var inputLegendTitles: [String]?
    
    var displayDataMode: ChartValueDisplayMode = .original
    
    init(inputDatas: [(Double, LiteChartDarkLightColor)]) {
        self.inputDatas = inputDatas
    }
    
}

extension FunalChartParameters {
    
    func checkInputDatasParameterInvalid() throws {
        guard self.inputDatas.count < 2 else {
            let filter = self.inputDatas.filter{
                $0.0 <= 0
            }
            if filter.isEmpty {
                return
            } else {
                throw ChartError.inputDatasMustPositive
            }
            
        }
        var front = -1
        for index in 0 ..< self.inputDatas.count {
            if self.inputDatas[index].0 <= 0 {
                throw ChartError.inputDatasMustPositive
            }
            if front == -1 {
                front = index
                continue
            }else if self.inputDatas[index].0 <= self.inputDatas[front].0 {
                front = index
                continue
            } else {
                throw ChartError.inputDatasNotTrueSorted
            }
        }
        return
    }
    
    func computeTitleConfigure() -> DisplayLabelConfigure? {
        guard let titleString = self.titleString else {
            return nil
        }
        return DisplayLabelConfigure(contentString: titleString, contentColor: textColor, textAlignment: .center)
    }
    
    func computeLegendViewConfigure() -> LegendViewsConfigure? {
        guard let inputLegendTitles = self.inputLegendTitles, self.inputDatas.count == inputLegendTitles.count else {
            return nil
        }
        var legendViewConfigures: [LegendViewConfigure] = []
        
        for index in 0 ..< self.inputDatas.count {
            let legendType = Legend.square
            let displayLabelConfigure = DisplayLabelConfigure(contentString: inputLegendTitles[index], contentColor: textColor, textAlignment: .left)
            let legendConfigure = LegendConfigure(color: self.inputDatas[index].1)
            let legendViewConfigure = LegendViewConfigure(legendType: legendType, legendConfigure: legendConfigure, contentConfigure: displayLabelConfigure)
            legendViewConfigures.append(legendViewConfigure)
        }
        
        return LegendViewsConfigure(models: legendViewConfigures)
        
    }
    
    func computeFunalViewComfigure() -> FunalViewConfigure {
        
        guard self.inputDatas.count > 0 else {
            return FunalViewConfigure()
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
        
        if !displayString.isEmpty && displayString.count != self.inputDatas.count {
            fatalError("此为框架内部处理数据不当产生的bug，不给予拯救!")
        }
        
        for index in 0 ..< self.inputDatas.count {
            let backgroundViewConfigure = FunalFloorBackagroundViewConfigure(color: self.inputDatas[index].1, topPercent: CGFloat(inputPercents[index].0), bottomPercent: CGFloat(inputPercents[index].1))
            
            if displayString.isEmpty {
                let funalFloorConfigure = FunalFloorViewConfigure(backgroundViewConfigure: backgroundViewConfigure)
                funalViewConfigure.append(funalFloorConfigure)
            } else {
                let contentViewConfigure = DisplayLabelConfigure(contentString: displayString[index], contentColor: textColor, textAlignment: .center)
                let funalFloorConfigure = FunalFloorViewConfigure(backgroundViewConfigure: backgroundViewConfigure, contentViewConfigure: contentViewConfigure)
                funalViewConfigure.append(funalFloorConfigure)
            }
        }
        
        return FunalViewConfigure(models: funalViewConfigure)
        
    }
    
    private func computePercentValue(for datas: [Double]) -> [Double] {
        guard let first = self.inputDatas.first else {
            return []
        }
        let firstData = first.0
        return self.inputDatas.map{
            $0.0 / firstData
        }
    }
    
    private func computeOriginalValue(for datas: [Double]) -> [Double] {
        return self.inputDatas.map{
            $0.0
        }
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


