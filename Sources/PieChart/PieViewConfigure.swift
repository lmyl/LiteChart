//
//  PieViewConfigure.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/8.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

struct PieViewConfigure {
    
    let pieSectorViewConfigures: [PieSectorViewConfigure]
    
    init(pieSectorViewConfigure: [PieSectorViewConfigure]) {
        self.pieSectorViewConfigures = pieSectorViewConfigure
    }
    
    private init() {
        self.pieSectorViewConfigures = []
    }
}

extension PieViewConfigure {
    static let emptyConfigure = PieViewConfigure()
}
