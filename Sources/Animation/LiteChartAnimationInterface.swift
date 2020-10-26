//
//  LiteChartAnimationInterface.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/10/16.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit

public struct LiteChartAnimationInterface {
    public var animationType: LiteChartAnimationType
    
    public var delay: CFTimeInterval
    
    public var fillModel: CAMediaTimingFillMode
    
    public var animationTimingFunction: LiteChartAnimationTimingFunction
    
    internal var timingFunction: CAMediaTimingFunction {
        animationTimingFunction.timingFunction
    }
}
