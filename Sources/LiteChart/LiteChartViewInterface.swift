//
//  LiteChartViewInterface.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/10/9.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation
import UIKit

struct LiteChartViewInterface {
    
    var isShowChartTitleString = false
    
    var chartTitleColor: LiteChartDarkLightColor = .init(lightColor: .black, darkColor: .white)
    
    var chartTitleString = ""
    
    var chartTitleDisplayLocation: ChartTitleDisplayLocation = .top
    
    var isShowLegendTitles = false
    
    var contentInterface: LiteChartInterface
    
    init(contentInterface: LiteChartInterface) {
        self.contentInterface = contentInterface
    }
    
    private init() {
        self.contentInterface = LiteChartBarChartInterface(inputDatas: [], coupleTitle: [])
    }
}

extension LiteChartViewInterface {
    static let emptyInterface = LiteChartViewInterface()
    
    func computeTitleConfigure() -> DisplayLabelConfigure? {
        guard self.isShowChartTitleString else {
            return nil
        }
        return DisplayLabelConfigure(contentString: self.chartTitleString, contentColor: chartTitleColor, textAlignment: .center)
    }
    
    func checkInputDatasParameterInvalid() throws {
        try self.contentInterface.parametersProcesser.checkInputDatasParameterInvalid()
    }
    
    func computeLegendViews(syncCenterIdentifier: String) -> UIView? {
        guard self.isShowLegendTitles else {
            return nil
        }
        return self.contentInterface.parametersProcesser.computeLegendViews(syncCenterIdentifier: syncCenterIdentifier)
    }
    
    func computeContentView(syncCenterIdentifier: String) -> LiteChartContentView {
        return self.contentInterface.parametersProcesser.computeContentView(syncCenterIdentifier: syncCenterIdentifier)
    }
}


