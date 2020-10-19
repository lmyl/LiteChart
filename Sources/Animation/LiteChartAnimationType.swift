//
//  LiteChartAnimationType.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/10/16.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation
import CoreGraphics

enum LiteChartAnimationType {
    case base(duration: CFTimeInterval)
    case spring(damping: CGFloat, mass: CGFloat, stiffness: CGFloat, initalVelocity: CGFloat)
}
