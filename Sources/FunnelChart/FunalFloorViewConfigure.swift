//
//  FunalFloorViewConfigure.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/5.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation

struct FunalFloorViewConfigure {
    
    let backgroundViewConfigure: FunalFloorBackagroundViewConfigure
    
    let contentViewConfigure: DisplayLabelConfigure
    
    let isShowLabel: Bool
    
    init(backgroundViewConfigure: FunalFloorBackagroundViewConfigure, isShowLabel: Bool, contentViewConfigure: DisplayLabelConfigure = .emptyConfigure) {
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

extension FunalFloorViewConfigure {
    static let emptyConfigure = FunalFloorViewConfigure()
}
