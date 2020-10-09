//
//  LiteChartViewBorderStyle.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/11.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation

enum LiteChartViewBorderStyle {
    case halfSurrounded
    case fullySurrounded
}

extension LiteChartViewBorderStyle {
    func convertToAxisBorderStyle() -> [AxisViewBorderStyle] {
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
