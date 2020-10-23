//
//  PieViewsConfigure.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/8.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation

struct PieViewsConfigure {
    let model: PieValueViewConfigure
    
    init(model: PieValueViewConfigure) {
        self.model = model
    }
    
    private init() {
        self.model = .emptyConfigure
    }
}

extension PieViewsConfigure {
    static let emptyConfigure = PieViewsConfigure()
}
