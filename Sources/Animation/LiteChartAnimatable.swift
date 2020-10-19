//
//  LiteChartAnimatable.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/10/13.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation

protocol LiteChartAnimatable {
    func startAnimation(animation: LiteChartAnimationInterface)
    
    func stopAnimation()
    
    func pauseAnimation()
    
    func continueAnimation()
    
    var animationStatus: LiteChartAnimationStatus { get }
}
