//
//  LiteChartViewParameters.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/8.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

struct LiteChartViewParameters {
    var titleString: String?
    
    var textColor: LiteChartDarkLightColor = .init(lightColor: .black, darkColor: .white)
    
    var inputDatas: LiteChartDatas
    
    var inputLegendTitles: [String]?
    
    var displayDataMode: ChartValueDisplayMode = .original
    
    var titleDisplayLocation: ChartTitleDisplayLocation = .top
    
    var coupleTitles: [String] = []
    
    var borderStyle: BarChartViewBorderStyle = .halfSurrounded
    
    var borderColor: LiteChartDarkLightColor = .init(lightColor: .black, darkColor: .white)
    
    var direction: BarChartDirection = .bottomToTop
    
    var dividingValueLineStyle: AxisViewLineStyle = .dotted
    
    var dividingValueLineColor: LiteChartDarkLightColor = .init(lightColor: .black, darkColor: .white)
    
    var dividingCoupleLineStyle: AxisViewLineStyle = .dotted
    
    var dividingCoupleLineColor: LiteChartDarkLightColor = .init(lightColor: .black, darkColor: .white)
        
    var isShowValueDividingLine = false
    
    var isShowCoupleDividingLine = false
    
    var valueUnitString: String?
    
    var coupleUnitString: String?
        
    var axisColor: LiteChartDarkLightColor = .init(lightColor: .black)
    
    private lazy var parametersProcesser: LiteChartParametersProcesser = {
        switch self.inputDatas {
        case .funal(let inputDatas):
            return FunalChartParameters(inputDatas: inputDatas, inputLegendTitles: self.inputLegendTitles, displayDataMode: self.displayDataMode, textColor: self.textColor)
        case .pie(let inputDatas):
            return PieChartParameters(inputDatas: inputDatas, inputLegendTitles: self.inputLegendTitles, displayDataMode: self.displayDataMode, textColor: self.textColor)
        case .bar(let inputDatas, let coupleTitle):
            return BarChartParameter(borderStyle: self.borderStyle, borderColor: self.borderColor, direction: self.direction, textColor: self.textColor, inputDatas: inputDatas, coupleTitle: coupleTitle, displayDataMode: self.displayDataMode, dividingLineStyle: self.dividingValueLineStyle, dividingLineColor: self.dividingValueLineColor, isShowValueDividingLine: self.isShowValueDividingLine, inputLegendTitles: self.inputLegendTitles, isShowCoupleDividingLine: self.isShowCoupleDividingLine, dividingCoupleLineStyle: self.dividingCoupleLineStyle, dividingCoupleLineColor: self.dividingCoupleLineColor, valueUnitString: self.valueUnitString, coupleUnitString: self.coupleUnitString)
        case .line(let inputDatas, let coupleTitle):
            return LineChartParameters(borderStyle: self.borderStyle, borderColor: self.borderColor, textColor: self.textColor, inputDatas: inputDatas, coupleTitles: coupleTitle, inputLegendTitles: self.inputLegendTitles, displayDataMode: self.displayDataMode, dividingValueLineStyle: self.dividingValueLineStyle, dividingValueLineColor: self.dividingValueLineColor, dividingCoupleLineStyle: self.dividingCoupleLineStyle, dividingCoupleLineColor: self.dividingValueLineColor, isShowValueDividingLine: self.isShowValueDividingLine, isShowCoupleDividingLine: self.isShowCoupleDividingLine, valueUnitString: self.valueUnitString, coupleUnitString: self.coupleUnitString, axisColor: self.axisColor)
        }
    }()
    
    init(inputDatas: LiteChartDatas) {
        self.inputDatas = inputDatas
    }
    
    init() {
        self.inputDatas = .funal(inputDatas: [])
    }
}

extension LiteChartViewParameters {
    
    
    func computeTitleConfigure() -> DisplayLabelConfigure? {
        guard let titleString = self.titleString else {
            return nil
        }
        return DisplayLabelConfigure(contentString: titleString, contentColor: textColor, textAlignment: .center)
    }
    
    mutating func checkInputDatasParameterInvalid() throws {
        try self.parametersProcesser.checkInputDatasParameterInvalid()
    }
    
    mutating func computeLegendViewConfigure() -> LegendViewsConfigure? {
        return self.parametersProcesser.computeLegendViewConfigure()
    }
    
    mutating func computeContentView() -> UIView {
        return self.parametersProcesser.computeContentView()
    }
    
    
}
