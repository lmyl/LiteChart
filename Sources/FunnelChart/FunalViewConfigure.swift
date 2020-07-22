//
//  FunalViewConfigure.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/5.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation

struct FunalViewConfigure {
    
    let models: [FunalFloorViewConfigure]
    
    init(models: [FunalFloorViewConfigure]) {
        self.models = models
    }
    
    private init() {
        self.models = []
    }
}

extension FunalViewConfigure {
    static let emptyconfigure = FunalViewConfigure()
}
