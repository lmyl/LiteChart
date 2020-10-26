//
//  LiteChartDarkLightColor.swift
//  
//
//  Created by 刘洋 on 2020/6/4.
//

import UIKit

public struct LiteChartDarkLightColor {
    
    private let lightColor: LiteChartColor
    private let darkColor: LiteChartColor?
    
    public init(lightColor: LiteChartColor, darkColor: LiteChartColor) {
        self.lightColor = lightColor
        self.darkColor = darkColor
    }
    
    public init(lightColor: LiteChartColor) {
        self.lightColor = lightColor
        self.darkColor = nil
    }
    
    public init(lightUIColor: UIColor, darkUIColor: UIColor) {
        let light = LiteChartColor.customColor(color: lightUIColor)
        let dark = LiteChartColor.customColor(color: darkUIColor)
        self.init(lightColor: light, darkColor: dark)
    }
    
    public init(lightUIColor: UIColor) {
        let light = LiteChartColor.customColor(color: lightUIColor)
        self.init(lightColor: light)
    }
    
    internal var color: UIColor {
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
