//
//  BarChartViewConfigure.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/11.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation
import CoreGraphics

struct BarChartViewConfigure {

    let direction: BarChartDirection
    
    let isShowValueUnitString: Bool
    
    let isShowCoupleUnitString: Bool
    
    let axisConfigure: AxisViewConfigure
    
    let valueUnitStringConfigure: DisplayLabelConfigure
    
    let coupleUnitStringConfigure: DisplayLabelConfigure
    
    let coupleTitleConfigure: [DisplayLabelConfigure]
    
    let valueTitleConfigure: [DisplayLabelConfigure]
    
    let barViewCoupleCollectionConfigure: BarViewCoupleCollectionConfigure
}

extension BarChartViewConfigure {
    private init() {
        self.direction = .bottomToTop
        self.isShowValueUnitString = false
        self.isShowCoupleUnitString = false
        self.axisConfigure = .emptyConfigure
        self.valueUnitStringConfigure = .emptyConfigure
        self.coupleUnitStringConfigure = .emptyConfigure
        self.coupleTitleConfigure = []
        self.valueTitleConfigure = []
        self.barViewCoupleCollectionConfigure = .emptyConfigure
    }
    
    static let emptyConfigure = BarChartViewConfigure()
    
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
    
    var barViewCoupleNumber: Int {
        self.barViewCoupleCollectionConfigure.models.count
    }
}

