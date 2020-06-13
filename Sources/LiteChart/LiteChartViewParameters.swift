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
    
    var borderColor: LiteChartDarkLightColor = .init(lightColor: .black)
    
    var direction: BarChartDirection = .bottomToTop
    
    var dividingLineStyle: AxisViewLlineStyle = .dotted
    
    var dividingColor: LiteChartDarkLightColor = .init(lightColor: .yellow)
    
    var numOfDividingLine: Int = 0
    
    
    private lazy var parametersProcesser: LiteChartParametersProcesser = {
        switch self.inputDatas {
        case .funal(let inputDatas):
            return FunalChartParameters(inputDatas: inputDatas, inputLegendTitles: self.inputLegendTitles, displayDataMode: self.displayDataMode, textColor: self.textColor)
        case .pie(inputDatas: let inputDatas):
            return PieChartParameters(inputDatas: inputDatas, inputLegendTitles: self.inputLegendTitles, displayDataMode: self.displayDataMode, textColor: self.textColor)
        case .bar(inputDates: let inputDatas):
            return BarChartParameter(borderStyle: self.borderStyle, borderColor: self.borderColor, direction: self.direction, textColor: self.textColor, inputDatas: inputDatas, coupleTitle: self.coupleTitles, displayDataMode: self.displayDataMode, dividingLineStyle: self.dividingLineStyle, dividingLineColor: self.dividingColor, numOfDividingLine: self.numOfDividingLine, inputLegendTitles: self.inputLegendTitles)
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
