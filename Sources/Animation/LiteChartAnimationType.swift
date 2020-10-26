//
//  LiteChartAnimationType.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/10/16.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit

public enum LiteChartAnimationType {
    case base(duration: CFTimeInterval)
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
