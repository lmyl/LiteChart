//
//  ChartKind.swift
//  LiteChart
//
//  Created by huangxiaohui on 2020/10/26.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation

enum ChartKind: String, CaseIterable {
    case RadarChart
    case BubbleChart
    case ScatterPlotChart
    case LineChart
    case BarChart
    case PieChart
    case FunnelChart
    
}

extension ChartKind: CustomStringConvertible {
    var description: String {
        switch self {
        case .RadarChart:
            return "雷达图(Radar)"
        case .BubbleChart:
            return "气泡图(Bubble)"
        case .ScatterPlotChart:
            return "散点图(Scatter)"
        case .LineChart:
            return "折线图(Line)"
        case .BarChart:
            return "柱状图(Bar)"
        case .PieChart:
            return "饼图(Pie)"
        case .FunnelChart:
            return "漏斗图(Funnel)"
        }
    }
}
