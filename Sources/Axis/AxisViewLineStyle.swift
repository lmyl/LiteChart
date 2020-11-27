//
//  AxisViewLineStyle.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/10.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation

/// Display type of coordinate axis
public enum AxisViewLineStyle {
    /// use solid line to draw axes
    case solid
    /// use dotted line to draw axes
    case dotted
    /// use short lines to identify line's locations
    /// 显示为长度小于4的短线
    case segment
}
