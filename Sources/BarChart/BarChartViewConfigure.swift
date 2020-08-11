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
    let textColor: LiteChartDarkLightColor
    
    let coupleTitle: [String]
    
    let valueTitle: [String]
    
    let inputDatas: [(LiteChartDarkLightColor ,[(String, CGFloat)])]
    
    let isShowLabel: Bool
    
    let direction: BarChartDirection
    
    let borderColor: LiteChartDarkLightColor
    
    let borderStyle: BarChartViewBorderStyle
    
    let xDividingPoints: [AxisDividingLineConfigure]
    
    let yDividingPoints: [AxisDividingLineConfigure]
    
    let isShowValueUnitString: Bool
    
    let isShowCoupleUnitString: Bool
    
    let valueUnitString: String
    
    let coupleUnitString: String
}

extension BarChartViewConfigure {
    private init() {
        self.textColor = .init(lightUIColor: .black, darkUIColor: .white)
        self.coupleTitle = []
        self.valueTitle = []
        self.inputDatas = []
        self.direction = .bottomToTop
        self.borderColor = .init(lightUIColor: .black, darkUIColor: .white)
        self.xDividingPoints = []
        self.yDividingPoints = []
        self.borderStyle = .halfSurrounded
        self.isShowValueUnitString = false
        self.isShowCoupleUnitString = false
        self.valueUnitString = ""
        self.coupleUnitString = ""
        self.isShowLabel = false
    }
    
    static let emptyConfigure = BarChartViewConfigure()
}

