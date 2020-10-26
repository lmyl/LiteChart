//
//  UIColor+Utilities.swift
//  
//
//  Created by 刘洋 on 2020/6/4.
//

import UIKit

extension UIColor {
    internal convenience init(sRGB3PRed red: Int, green: Int, blue: Int) {
        self.init(displayP3Red: CGFloat(red) / 255 , green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: 1)
    }
}
