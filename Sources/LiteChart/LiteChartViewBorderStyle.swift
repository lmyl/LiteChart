//
//  LiteChartViewBorderStyle.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/11.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation

/// The border style of chart view, the default type is half surrounded to show axis
/// 绘图区边框的类型，默认半包围显示坐标轴
public enum LiteChartViewBorderStyle {
    /// half surrounded
    case halfSurrounded
    /// fully surrounded
    case fullySurrounded
}

extension LiteChartViewBorderStyle {
    internal func convertToAxisBorderStyle() -> [AxisViewBorderStyle] {
        let borderStlye: [AxisViewBorderStyle]
        switch self {
        case .halfSurrounded:
            borderStlye = [.left, .bottom]
        case .fullySurrounded:
            borderStlye = [.left, .bottom, .right, .top]
        }
        return borderStlye
    }
}
