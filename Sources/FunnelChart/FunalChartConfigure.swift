//
//  FunalChartConfigure.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/6.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation

struct FunalChartConfigure {
    let chartTitleConfigure: DisplayLabelConfigure?
    
    let funalViewConfigure: FunalViewConfigure
    
    let legendViewsConfigure: LegendViewsConfigure?
    
    init(funalViewConfigure: FunalViewConfigure, chartTitleConfigure: DisplayLabelConfigure?, legendViewsConfigure: LegendViewsConfigure?) {
        self.chartTitleConfigure = chartTitleConfigure
        self.funalViewConfigure = funalViewConfigure
        self.legendViewsConfigure = legendViewsConfigure
    }
    
    init() {
        self.funalViewConfigure = FunalViewConfigure()
        self.chartTitleConfigure = nil
        self.legendViewsConfigure = nil
    }
}
