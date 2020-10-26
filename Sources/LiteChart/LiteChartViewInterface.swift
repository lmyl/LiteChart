//
//  LiteChartViewInterface.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/10/9.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation
import UIKit

public struct LiteChartViewInterface {
    
    public var isShowChartTitleString = false
    
    public var chartTitleColor: LiteChartDarkLightColor = .init(lightColor: .black, darkColor: .white)
    
    public var chartTitleString = ""
    
    public var chartTitleDisplayLocation: ChartTitleDisplayLocation = .top
    
    public var isShowLegendTitles = false
    
    private var contentInterface: LiteChartInterface
    
    public init(contentInterface: LiteChartInterface) {
        self.contentInterface = contentInterface
    }
    
    private init() {
        self.contentInterface = LiteChartBarChartInterface(inputDatas: [], coupleTitle: [])
    }
}

extension LiteChartViewInterface {
    public static let emptyInterface = LiteChartViewInterface()
    
    internal func computeTitleConfigure() -> DisplayLabelConfigure? {
        guard self.isShowChartTitleString else {
            return nil
        }
        return DisplayLabelConfigure(contentString: self.chartTitleString, contentColor: chartTitleColor, textAlignment: .center)
    }
    
    internal func checkInputDatasParameterInvalid() throws {
        try self.contentInterface.parametersProcesser.checkInputDatasParameterInvalid()
    }
    
    internal func computeLegendViews(syncCenterIdentifier: String) -> UIView? {
        guard self.isShowLegendTitles else {
            return nil
        }
        return self.contentInterface.parametersProcesser.computeLegendViews(syncCenterIdentifier: syncCenterIdentifier)
    }
    
    internal func computeContentView(syncCenterIdentifier: String) -> LiteChartContentView {
        return self.contentInterface.parametersProcesser.computeContentView(syncCenterIdentifier: syncCenterIdentifier)
    }
}


