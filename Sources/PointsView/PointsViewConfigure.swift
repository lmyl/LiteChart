//
//  PointsViewConfigure.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/20.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation

struct PointsViewConfigure {
    let points: [PointConfigure]
}

extension PointsViewConfigure {
    private init() {
        self.points = []
    }
    
    static let emptyConfigure = PointsViewConfigure()
}
