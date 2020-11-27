//
//  LiteChartAnimationType.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/10/16.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit

/// Enumeration of chart animation types
public enum LiteChartAnimationType {
    /// Base animation.
    /// 基本动画
    case base(duration: CFTimeInterval)
    /// Spring animation. Radar Chart, Funnel Chart, Line Chart and Pie Chart are not supported.
    /// 弹簧动画，不支持漏斗图、饼状图、折线图、雷达图
    case spring(damping: CGFloat, mass: CGFloat, stiffness: CGFloat, initalVelocity: CGFloat)
}

extension LiteChartAnimationType {
    internal func quickAnimation(keyPath: String) -> CABasicAnimation {
        switch self {
        case .base(let duration):
            let animation = CABasicAnimation(keyPath: keyPath)
            animation.duration = duration
            return animation
        case .spring(let damping, let mass, let stiffness, let initalVelocity):
            let animation = CASpringAnimation(keyPath: keyPath)
            animation.damping = damping
            animation.mass = mass
            animation.stiffness = stiffness
            animation.initialVelocity = initalVelocity
            animation.duration = animation.settlingDuration
            return animation
        }
    }
}
