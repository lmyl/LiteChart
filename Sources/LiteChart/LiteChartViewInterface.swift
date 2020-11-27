//
//  LiteChartViewInterface.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/10/9.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation
import UIKit

/// Parameters interface of the whole chart
public struct LiteChartViewInterface {
    
    /// Whether to display the title of the chart, not displayed by default
    public var isShowChartTitleString = false
    
    /// The color of chart's title
    public var chartTitleColor: LiteChartDarkLightColor = .init(lightColor: .black, darkColor: .white)
    
    /// The content of chart's title
    public var chartTitleString = ""
    
    /// The display position of the chart title, which is displayed at the top of the chart by default
    public var chartTitleDisplayLocation: ChartTitleDisplayLocation = .top
    
    /// Whether to display the legend titles
    public var isShowLegendTitles = false
    
    private var contentInterface: LiteChartInterface
    
    /// Main chart view initialization
    /// - Parameter contentInterface: Instance of LiteChartInterface
    public init(contentInterface: LiteChartInterface) {
        self.contentInterface = contentInterface
    }
    
    private init() {
        self.contentInterface = LiteChartBarChartInterface(inputDatas: [], coupleTitle: [])
    }
}

extension LiteChartViewInterface {
    /// Instance of LiteChartViewInterface without any custom parameters
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


