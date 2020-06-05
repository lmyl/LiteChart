//
//  LiteChartDarkLightColor.swift
//  
//
//  Created by 刘洋 on 2020/6/4.
//

import UIKit

struct LiteChartDarkLightColor {
    
    private let lightColor: LiteChartColor
    private let darkColor: LiteChartColor?
    
    init(lightColor: LiteChartColor, darkColor: LiteChartColor) {
        self.lightColor = lightColor
        self.darkColor = darkColor
    }
    
    init(lightColor: LiteChartColor) {
        self.lightColor = lightColor
        self.darkColor = nil
    }
    
    var color: UIColor {
        if let darkColor = self.darkColor {
            return  UIColor(dynamicProvider: {
                traitCollection in
                if traitCollection.userInterfaceStyle == .dark {
                    return darkColor.color
                } else {
                    return self.lightColor.color
                }
            })
        } else {
            return self.lightColor.color
        }
    }
    
    
}
