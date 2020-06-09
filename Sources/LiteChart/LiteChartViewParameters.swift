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
    
    private lazy var parametersProcesser: LiteChartParametersProcesser = {
        switch self.inputDatas {
        case .funal(let inputDatas):
            return FunalChartParameters(inputDatas: inputDatas, inputLegendTitles: self.inputLegendTitles, displayDataMode: self.displayDataMode, textColor: self.textColor)
        case .pie(inputDatas: let inputDatas):
            return PieChartParameters(inputDatas: inputDatas, inputLegendTitles: self.inputLegendTitles, displayDataMode: self.displayDataMode, textColor: self.textColor)
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
