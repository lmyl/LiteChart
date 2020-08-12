//
//  LegendFactory.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/8/12.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit

class LegendFactory {
    static let shared = LegendFactory()
    
    private init() { }
    
    func makeNewLegend(from: LegendConfigure) -> UIView {
        let color = from.color
        switch from.type {
        case .square:
            return SquareLegend(color: color)
        case .triangle:
            return TriangleLegend(color: color)
        case .circle:
            return CircleLegend(color: color)
        case .pentagram:
            return PentagramLegend(color: color)
        case .hexagon:
            return HexagonLegend(color: color)
        }
    }
}
