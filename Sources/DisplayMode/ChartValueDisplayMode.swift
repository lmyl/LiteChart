//
//  PercentDisplayMode.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/7.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation

/// Enumeration representing the type of data display
public enum ChartValueDisplayMode {
    /// Display data in raw type
    /// 显示数据的原始值
    case original
    /// Display data as a percentage
    /// 显示数据的百分数形式
    case percent
    /// Simultaneously display the percentage of data and the original data
    /// 同时显示数据的百分数形式与原始形式
    case mix
    /// Hide data
    /// 不显示数据
    case none
}
