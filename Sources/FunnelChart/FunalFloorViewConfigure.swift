//
//  FunalFloorViewConfigure.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/5.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation

struct FunalFloorViewConfigure {
    
    static let emptyConfigure = FunalFloorViewConfigure()
    
    let backgroundViewConfigure: FunalFloorBackagroundViewConfigure
    
    let contentViewConfigure: DisplayLabelConfigure
    
    let isShowLabel: Bool
    
    init(backgroundViewConfigure: FunalFloorBackagroundViewConfigure, contentViewConfigure: DisplayLabelConfigure, isShowLabel: Bool = true) {
        self.backgroundViewConfigure = backgroundViewConfigure
        self.contentViewConfigure = contentViewConfigure
        self.isShowLabel = isShowLabel
    }
    
    private init() {
        self.backgroundViewConfigure = .emptyConfigure
        self.contentViewConfigure = .emptyConfigure
        self.isShowLabel = false
    }
}
