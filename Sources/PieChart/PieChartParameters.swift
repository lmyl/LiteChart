//
//  PieChartParameters.swift
//  LiteChart
//
//  Created by huangxiaohui on 2020/6/9.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit

struct PieChartParameters {
    
    var inputDatas: [(Double, LiteChartDarkLightColor)]
    
    var inputLegendTitles: [String]
    
    var displayDataMode: ChartValueDisplayMode
    
    init(inputDatas: [(Double, LiteChartDarkLightColor)], inputLegendTitles: [String], displayDataMode: ChartValueDisplayMode) {
        self.inputDatas = inputDatas
        self.inputLegendTitles = inputLegendTitles
        self.displayDataMode = displayDataMode
    }
    
}

extension PieChartParameters: LiteChartParametersProcesser {
    func checkInputDatasParameterInvalid() throws {
        if self.inputDatas.contains(where: {
            $0.0 <= 0
        }) {
            throw ChartError.inputDatasMustPositive
        }
    }

    func computeLegendViews(syncCenterIdentifier: String) -> UIView? {
        guard self.inputDatas.count == self.inputLegendTitles.count else {
            return nil
        }
        var legendViewConfigures: [LegendViewConfigure] = []
        let syncIdentifier = DisplayLabelSyncIdentifier(syncCenterIdentifier: syncCenterIdentifier, syncIdentifierType: .pieLegendTitleLabel)
        for index in 0 ..< self.inputDatas.count {
            let legendType = Legend.square
            let legendConfigure = LegendConfigure(type: legendType, color: self.inputDatas[index].1)
            let displayLabelConfigure = DisplayLabelConfigure(contentString: inputLegendTitles[index], contentColor: self.inputDatas[index].1, textAlignment: .left, syncIdentifier: syncIdentifier)
            let legendViewConfigure = LegendViewConfigure(legendConfigure: legendConfigure, contentConfigure: displayLabelConfigure)
            legendViewConfigures.append(legendViewConfigure)
        }
        let legendConfigure = LegendViewsConfigure(models: legendViewConfigures)
        return LegendViews(configure: legendConfigure)
    }

    func computeContentView(syncCenterIdentifier: String) -> LiteChartContentView {
        guard self.inputDatas.count > 0 else {
            let configure = PieViewsConfigure.emptyConfigure
            return PieViews(configure: configure)
        }
        
        let datas = self.inputDatas.map{
            $0.0
        }
        let percents = self.computePercentValue(for: datas)
        var angle: [(Double, Double)] = []
        var base: Double = 0
        for index in 0 ..< percents.count {
            angle.append((base, base + percents[index] * 360))
            base += percents[index] * 360
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
        
        
        if self.displayDataMode != .none && displayString.count != self.inputDatas.count {
            fatalError("此为框架内部处理数据不当产生的bug，不给予拯救!")
        }
        let syncIdentifier = DisplayLabelSyncIdentifier(syncCenterIdentifier: syncCenterIdentifier, syncIdentifierType: .pieTitleLabel)
        var pieSectorViewConfigures: [PieSectorViewConfigure] = []
        var lineColors: [LiteChartDarkLightColor] = []
        var displayTextConfigures: [DisplayLabelConfigure] = []
        let isShowLabel = self.displayDataMode != .none
        for index in 0 ..< self.inputDatas.count {
            let pieSectorViewConfigure = PieSectorViewConfigure(startAngle: CGFloat(angle[index].0), endAngle: CGFloat(angle[index].1), backgroundColor: self.inputDatas[index].1)
            pieSectorViewConfigures.append(pieSectorViewConfigure)
            lineColors.append(self.inputDatas[index].1)
            if !isShowLabel {
                displayTextConfigures.append(.emptyConfigure)
            } else {
                let alignment: NSTextAlignment = pieSectorViewConfigure.isLeftSector ? .right : .left
                let labelConfigure = DisplayLabelConfigure(contentString: displayString[index], contentColor: self.inputDatas[index].1, textAlignment: alignment, syncIdentifier: syncIdentifier)
                displayTextConfigures.append(labelConfigure)
            }
        }
        let pieViewConfigure = PieViewConfigure(pieSectorViewConfigure: pieSectorViewConfigures)
        let pieLineViewConfigure = PieLineViewConfigure(pieViewConfigure: pieViewConfigure, lineColors: lineColors, isShowLine: isShowLabel)
        let pieValueViewConfigure = PieValueViewConfigure(pieLineViewConfigure: pieLineViewConfigure, displayTextConfigures: displayTextConfigures, isShowLable: isShowLabel)
        let configure = PieViewsConfigure(model: pieValueViewConfigure)
        return PieViews(configure: configure)
    }
    
    private func computePercentValue(for datas: [Double]) -> [Double] {
        let total = datas.reduce(0, +)
        return datas.map{
            $0 / total
        }
    }
    
    private func computeOriginalValue(for datas: [Double]) -> [Double] {
        return datas
    }
    
    private func computeMixValue(for datas: [Double]) -> [(original: Double, percent: Double)] {
        let original: [Double] = self.computeOriginalValue(for: datas)
        let percent: [Double] = self.computePercentValue(for: datas)
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

    private func computePercentString(for datas: [Double]) -> [String] {
        let formatter = self.displayPercentFormatter
        return self.computePercentValue(for: datas).map{
            let nsNumber = $0 as NSNumber
            return formatter.string(from: nsNumber) ?? "Data Error!"
        }
    }
    
    private func computeOriginalString(for datas: [Double]) -> [String] {
        let formatter = self.displayOriginalFormatter
        return self.computeOriginalValue(for: datas).map{
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
