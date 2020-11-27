//
//  LiteChartDarkLightColor.swift
//  
//
//  Created by 刘洋 on 2020/6/4.
//

import UIKit

/// The color display in the framework
public struct LiteChartDarkLightColor {
    
    private let lightColor: LiteChartColor
    private let darkColor: LiteChartColor?
    
    /// Light and dark color initialization using `LiteChartColor`
    /// - Parameters:
    ///   - lightColor: Color displayed in normal mode
    ///   - darkColor: Color displayed in dark mode
    public init(lightColor: LiteChartColor, darkColor: LiteChartColor) {
        self.lightColor = lightColor
        self.darkColor = darkColor
    }
    
    /// Light color initialization using `LiteChartColor`
    /// - Parameter lightColor: Color displayed in normal mode
    public init(lightColor: LiteChartColor) {
        self.lightColor = lightColor
        self.darkColor = nil
    }
    
    /// Light and dark color initialization using `UIColor`
    /// - Parameters:
    ///   - lightUIColor: Color displayed in normal mode
    ///   - darkUIColor: Color displayed in dark mode
    public init(lightUIColor: UIColor, darkUIColor: UIColor) {
        let light = LiteChartColor.customColor(color: lightUIColor)
        let dark = LiteChartColor.customColor(color: darkUIColor)
        self.init(lightColor: light, darkColor: dark)
    }
    
    /// Light color initialization using `UIColor`
    /// - Parameter lightUIColor: Color displayed in normal mode
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
