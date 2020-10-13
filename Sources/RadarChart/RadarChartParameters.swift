//
//  RadarChartParameters.swift
//  LiteChart
//
//  Created by huangxiaohui on 2020/6/23.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit

struct RadarChartParameters {
    
    var inputDatas: [(LiteChartDarkLightColor, [Double])]
    
    var isShowingCoupleTitles: Bool
    
    var coupleTitles: [String]
    
    var coupleTitlesColor: LiteChartDarkLightColor
    
    var inputLegendTitles: [String]
    
    var radarLineColor: LiteChartDarkLightColor
    
    var radarLightColor: LiteChartDarkLightColor
    
    var radarUnlightColor: LiteChartDarkLightColor
    
    var radarCount: Int
    
    init(inputDatas: [(LiteChartDarkLightColor, [Double])],
         isShowingCoupleTitles: Bool,
         coupleTitles: [String],
         coupleTitlesColor: LiteChartDarkLightColor,
         inputLegendTitles: [String],
         radarLineColor: LiteChartDarkLightColor,
         radarLightColor: LiteChartDarkLightColor,
         radarUnlightColor: LiteChartDarkLightColor,
         radarCount: Int) {
        self.inputDatas = inputDatas
        self.isShowingCoupleTitles = isShowingCoupleTitles
        self.coupleTitles = coupleTitles
        self.coupleTitlesColor = coupleTitlesColor
        self.inputLegendTitles = inputLegendTitles
        self.inputLegendTitles = inputLegendTitles
        self.radarLineColor = radarLineColor
        self.radarLightColor = radarLightColor
        self.radarUnlightColor = radarUnlightColor
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
            if self.isShowingCoupleTitles && self.coupleTitles.count != firstDataCount {
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
    
    func computeLegendViews() -> UIView? {
        guard self.inputDatas.count == self.inputLegendTitles.count else {
            return nil
        }
        var legendViewConfigures: [LegendViewConfigure] = []
        for index in 0 ..< self.inputDatas.count {
            let legendType = Legend.square
            let displayLabelConfigure = DisplayLabelConfigure(contentString: inputLegendTitles[index], contentColor: self.inputDatas[index].0, textAlignment: .left, syncIdentifier: .radarLegendTitleLabel)
            let legendConfigure = LegendConfigure(type: legendType, color: self.inputDatas[index].0)
            let legendViewConfigure = LegendViewConfigure(legendConfigure: legendConfigure, contentConfigure: displayLabelConfigure)
            legendViewConfigures.append(legendViewConfigure)
        }
        let legendConfigure = LegendViewsConfigure(models: legendViewConfigures)
        return LegendViews(configure: legendConfigure)
    }
    
    func computeContentView() -> LiteChartContentView {
        guard self.inputDatas.count > 0 else {
            let configure = RadarChartViewConfigure.emptyConfigure
            return RadarChartView(configure: configure)
        }
        let pointCount = self.inputDatas[0].1.count
        var inputDatas: [[Double]] = []
        for inputData in self.inputDatas {
            inputDatas.append(inputData.1)
        }
        var angles = [Double]()
        for index in 0 ..< pointCount {
            let angle = 360 / Double(pointCount) * Double(index) - 90
            angles.append(angle)
        }
        
        let proportionValues = convertProportionValue(datas: inputDatas)
        var radarDataViewsConfigure: [RadarDataViewConfigure] = []
        for index in 0 ..< self.inputDatas.count {
            let color = self.inputDatas[index].0
            let radarDataViewConfigure =  RadarDataViewConfigure(points: proportionValues[index], angleOfPoints: angles, color: color)
            radarDataViewsConfigure.append(radarDataViewConfigure)
        }
        
        let backgroundConfigure = RadarBackgroundViewConfigure(radarLineColor: self.radarLineColor, radarLightColor: self.radarLightColor, radarUnlightColor: self.radarUnlightColor, radarLayerCount: self.radarCount, angleOfPoints: angles)
        
        var coupleTitlesConfigure: [DisplayLabelConfigure] = []
        if self.isShowingCoupleTitles {
            let locationOfPoints = backgroundConfigure.locationOfPoints
            guard locationOfPoints.count == self.coupleTitles.count else {
                fatalError("框架内部错误，不给予拯救")
            }
            for (index, coupleTitle) in self.coupleTitles.enumerated() {
                let textAligment: NSTextAlignment
                switch locationOfPoints[index] {
                case .left:
                    textAligment = .right
                case .right:
                    textAligment = .left
                case .bottom, .top:
                    textAligment = .center
                }
                let coupleTitleConfigure = DisplayLabelConfigure(contentString: coupleTitle, contentColor: self.coupleTitlesColor, textAlignment: textAligment, syncIdentifier: .radarCoupleTitleLabel)
                coupleTitlesConfigure.append(coupleTitleConfigure)
            }
        }
        
        let radarChartViewConfigure = RadarChartViewConfigure(backgroundConfigure: backgroundConfigure, radarDataViewsConfigure: radarDataViewsConfigure, isShowCoupleTitles: self.isShowingCoupleTitles, coupleTitlesConfigure: coupleTitlesConfigure)
        return RadarChartView(configure: radarChartViewConfigure)
        
    }
    
    private func convertProportionValue(datas: [[Double]]) -> [[CGFloat]] {
        return datas.map{
            $0.map{
                CGFloat($0)
            }
        }
    }
    
}
