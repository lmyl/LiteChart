//
//  RadarChartParameters.swift
//  LiteChart
//
//  Created by huangxiaohui on 2020/6/23.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit

struct RadarChartParameters {
    
    var coupleTitles: [String]
    
    var isShowingCoupleTitles: Bool
    
    var inputLegendTitles: [String]?
    
    var textColor: LiteChartDarkLightColor
    
    var radarLineColor: LiteChartDarkLightColor
    
    var radarLightColor: LiteChartDarkLightColor
    
    var radarUnlightColor: LiteChartDarkLightColor
        
    var inputDatas: [(LiteChartDarkLightColor, [Double])]
    
    var radarCount: Int
    
    init(coupleTitles: [String], isShowingCoupleTitles: Bool, inputLegendTitles: [String]?, textColor: LiteChartDarkLightColor, radarLineColor: LiteChartDarkLightColor, radarLightColor: LiteChartDarkLightColor, radarUnlightColor: LiteChartDarkLightColor, inputDatas: [(LiteChartDarkLightColor, [Double])], radarCount: Int) {
        self.coupleTitles = coupleTitles
        self.isShowingCoupleTitles = isShowingCoupleTitles
        self.inputLegendTitles = inputLegendTitles
        self.textColor = textColor
        self.radarLineColor = radarLineColor
        self.radarLightColor = radarLightColor
        self.radarUnlightColor = radarUnlightColor
        self.inputDatas = inputDatas
        self.radarCount = radarCount
    }
    
}

extension RadarChartParameters: LiteChartParametersProcesser {
    func checkInputDatasParameterInvalid() throws {
        let inputDatas = self.inputDatas
        if inputDatas.count > 0 {
            let firstDataCount = inputDatas[0].1.count
            if firstDataCount < 3 {
                throw ChartError.inputDatasNumberLessThanLimit
            }
            if self.coupleTitles.count > 0 && self.coupleTitles.count != firstDataCount{
                throw ChartError.inputDatasNumbersNotMatchedCoupleTitle
            }
            for inputData in inputDatas {
                if inputData.1.count != firstDataCount {
                    throw ChartError.inputDatasNumberMustEqualForCouple
                }
                var contains = inputData.1.contains(where: { $0 < 0})
                if contains {
                    throw ChartError.inputDatasMustPositive
                }
                contains = inputData.1.contains(where: {$0 > 1})
                if contains {
                    throw ChartError.inputDatasMustLessAndEqualThan(number: 1)
                }
            }
        }
    }
    
    func computeLegendViewConfigure() -> LegendViewsConfigure? {
        guard let inputLegendTitles = self.inputLegendTitles, self.inputDatas.count == inputLegendTitles.count else {
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
            let configure = RadarChartViewConfigure()
            return RadarChartView(configure: configure)
        }
        let pointCount = self.inputDatas[0].1.count
        var inputDatas: [[Double]] = []
        for inputData in self.inputDatas {
            inputDatas.append(inputData.1)
        }
        
        let proportionValues = convertProportionValue(datas: inputDatas)
        var radarDataViewsConfigure: [RadarDataViewConfigure] = []
        for index in 0 ..< self.inputDatas.count {
            let color = self.inputDatas[index].0
            let radarDataViewConfigure =  RadarDataViewConfigure(points: proportionValues[index], color: color)
            radarDataViewsConfigure.append(radarDataViewConfigure)
        }
        
        var coupleTitlesConfigure: [DisplayLabelConfigure] = []
        if self.coupleTitles.count > 0 {
            for coupleTitle in self.coupleTitles {
                let coupleTitleConfigure = DisplayLabelConfigure(contentString: coupleTitle, contentColor: textColor)
                coupleTitlesConfigure.append(coupleTitleConfigure)
            }
            if coupleTitlesConfigure.count != pointCount {
                fatalError("框架内部数据处理错误，不给予拯救")
            }
        }
        
        if self.isShowingCoupleTitles {
            let configure = RadarBackgroundViewConfigure(coupleTitlesConfigure: coupleTitlesConfigure, radarLineColor: self.radarLineColor, radarLightColor: self.radarLightColor, radarUnlightColor: self.radarUnlightColor, radarCount: self.radarCount, pointCount: pointCount)
            let radarChartViewConfigure = RadarChartViewConfigure(backgroundConfigure: configure, radarDataViewsConfigure: radarDataViewsConfigure)
            return RadarChartView(configure: radarChartViewConfigure)
        } else {
            let configure = RadarBackgroundViewConfigure(coupleTitlesConfigure: [], radarLineColor: self.radarLineColor, radarLightColor: self.radarLightColor, radarUnlightColor: self.radarUnlightColor, radarCount: self.radarCount, pointCount: pointCount)
            let radarChartViewConfigure = RadarChartViewConfigure(backgroundConfigure: configure, radarDataViewsConfigure: radarDataViewsConfigure)
            return RadarChartView(configure: radarChartViewConfigure)
        }
        
    }
    
    private func convertProportionValue(datas: [[Double]]) -> [[CGFloat]] {
        return datas.map{
            $0.map{
                CGFloat($0)
            }
        }
    }
    
}