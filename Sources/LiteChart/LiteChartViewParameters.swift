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
    var titleString: String = ""
    
    var isShowTitleString: Bool = false
    
    var textColor: LiteChartDarkLightColor = .init(lightColor: .black, darkColor: .white)
    
    var inputDatas: LiteChartDatas
    
    var inputLegendTitles: [String] = []
    
    var isShowLegendTitles = false
    
    var displayDataMode: ChartValueDisplayMode = .original
    
    var titleDisplayLocation: ChartTitleDisplayLocation = .top
    
    var radarCoupleTitles: [String] = []
    
    var borderStyle: LiteChartViewBorderStyle = .halfSurrounded
    
    var borderColor: LiteChartDarkLightColor = .init(lightColor: .black, darkColor: .white)
    
    var barDirection: BarChartDirection = .bottomToTop
    
    var dividingValueLineStyle: AxisViewLineStyle = .dotted
    
    var dividingValueLineColor: LiteChartDarkLightColor = .init(lightColor: .black, darkColor: .white)
    
    var dividingCoupleLineStyle: AxisViewLineStyle = .dotted
    
    var dividingCoupleLineColor: LiteChartDarkLightColor = .init(lightColor: .black, darkColor: .white)
        
    var isShowValueDividingLine = false
    
    var isShowCoupleDividingLine = false
    
    var isShowValueUnitString = false
    
    var isShowCoupleUnitString = false
    
    var isShowRadarCoupleTitles = false
    
    var valueUnitString = ""
    
    var coupleUnitString = ""
        
    var axisColor: LiteChartDarkLightColor = .init(lightColor: .black)
    
    var isShowAxis = true
    
    var radarLineColor: LiteChartDarkLightColor = .init(lightColor: .Gray)
    
    var radarLightColor: LiteChartDarkLightColor = .init(lightColor: .white)
    
    var radarUnlightColor: LiteChartDarkLightColor = .init(lightColor: .lightGray)
    
    var radarLayerCount: Int = 1
}
