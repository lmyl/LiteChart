//
//  PlotChartViewConfigure.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/20.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation
import CoreGraphics

struct PlotChartViewConfigure {
    
    let isShowValueUnitString: Bool
    
    let isShowCoupleUnitString: Bool
    
    let axisConfigure: AxisViewConfigure
    
    let valueUnitStringConfigure: DisplayLabelConfigure
    
    let coupleUnitStringConfigure: DisplayLabelConfigure
    
    let coupleTitleConfigure: [DisplayLabelConfigure]
    
    let valueTitleConfigure: [DisplayLabelConfigure]
        
    let pointViewsConfigure: PointViewsConfigure
}

extension PlotChartViewConfigure {
    private init() {
        self.isShowValueUnitString = false
        self.isShowCoupleUnitString = false
        self.axisConfigure = .emptyConfigure
        self.valueUnitStringConfigure = .emptyConfigure
        self.coupleUnitStringConfigure = .emptyConfigure
        self.coupleTitleConfigure = []
        self.valueTitleConfigure = []
        self.pointViewsConfigure = .emptyConfigure
    }
    
    static let emptyConfigure = PlotChartViewConfigure()
    
    var yDividingPoints: [CGFloat] {
        self.axisConfigure.verticalDividingPoints.map({
            $0.location
        })
    }
    
    var xDividingPoints: [CGFloat] {
        self.axisConfigure.horizontalDividingPoints.map({
            $0.location
        })
    }
}
