//
//  LiteChartAnimationInterface.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/10/16.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit

struct LiteChartAnimationInterface {
    var animationType: LiteChartAnimationType
    
    var delay: CFTimeInterval
    
    var fillModel: CAMediaTimingFillMode
    
    var animationTimingFunction: LiteChartAnimationTimingFunction
    
    internal var timingFunction: CAMediaTimingFunction {
        animationTimingFunction.timingFunction
    }
}
