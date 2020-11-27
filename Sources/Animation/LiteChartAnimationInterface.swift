//
//  LiteChartAnimationInterface.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/10/16.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit

/// Parameters interface of chart's animation
public struct LiteChartAnimationInterface {
    /// Set the animation type of the whole chart
    /// 设置图表动画的类型
    public var animationType: LiteChartAnimationType
    
    /// Set the delay of animation
    /// 设置动画延迟时长
    public var delay: CFTimeInterval
    
    /// Determine the behavior of the chart during non-animation
    /// 决定图表在非动画过程时的行为
    public var fillModel: CAMediaTimingFillMode
    
    /// Set the time control type of the animation
    /// 设置动画的时间控制类型
    public var animationTimingFunction: LiteChartAnimationTimingFunction
    
    internal var timingFunction: CAMediaTimingFunction {
        animationTimingFunction.timingFunction
    }
}
