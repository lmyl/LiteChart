//
//  PieViewsConfigure.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/8.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation

struct PieViewsConfigure {
    let models: [PieViewConfigure]
    
    init(models: [PieViewConfigure]) {
        self.models = models
    }
    
    init() {
        self.models = []
    }
}
