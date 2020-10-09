//
//  LineChartViewConfigure.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/17.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation
import CoreGraphics

struct LineChartViewConfigure {
    
    let isShowValueUnitString: Bool
    
    let isShowCoupleUnitString: Bool
    
    let axisConfigure: AxisViewConfigure
    
    let valueUnitStringConfigure: DisplayLabelConfigure
    
    let coupleUnitStringConfigure: DisplayLabelConfigure
    
    let coupleTitleConfigure: [DisplayLabelConfigure]
    
    let valueTitleConfigure: [DisplayLabelConfigure]
    
    let lineViewsConfigure: LineViewsConfigure
    
}

extension LineChartViewConfigure {
    private init() {
        self.isShowCoupleUnitString = false
        self.isShowValueUnitString = false
        self.axisConfigure = .emptyConfigure
        self.valueUnitStringConfigure = .emptyConfigure
        self.coupleUnitStringConfigure = .emptyConfigure
        self.valueTitleConfigure = []
        self.coupleTitleConfigure = []
        self.lineViewsConfigure = .emptyConfigure
    }
    
    static let emptyConfigure = LineChartViewConfigure()
    
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
