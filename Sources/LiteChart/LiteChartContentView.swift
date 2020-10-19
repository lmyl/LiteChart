//
//  LiteChartContentView.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/10/12.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit

class LiteChartContentView: UIView, LiteChartAreaLayoutGuide, LiteChartAnimatable {
    var areaLayoutGuide: UILayoutGuide {
        self.safeAreaLayoutGuide
    }
    
    var animationStatus: LiteChartAnimationStatus {
        return .ready
    }
    
    func startAnimation(animation: LiteChartAnimationInterface) {
        
    }
    
    func pauseAnimation() {
        
    }
    
    func stopAnimation() {
        
    }
    
    func continueAnimation() {
        
    }
}
