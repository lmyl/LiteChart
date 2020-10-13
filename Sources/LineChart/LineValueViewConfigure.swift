//
//  LineValueViewConfigure.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/10/13.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation
import CoreGraphics

struct LineValueViewConfigure {
    let points: [[CGPoint]]
    let labelConfigure: [[DisplayLabelConfigure]]
}

extension LineValueViewConfigure {
    private init() {
        self.points = []
        self.labelConfigure = []
    }
    
    static let emptyConfigure = LineValueViewConfigure()
}
