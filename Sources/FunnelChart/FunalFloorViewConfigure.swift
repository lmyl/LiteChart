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
    
    let contentViewConfigure: DisplayLabelConfigure?
    
    init(backgroundViewConfigure: FunalFloorBackagroundViewConfigure, contentViewConfigure: DisplayLabelConfigure) {
        self.backgroundViewConfigure = backgroundViewConfigure
        self.contentViewConfigure = contentViewConfigure
    }
    
    init(backgroundViewConfigure: FunalFloorBackagroundViewConfigure) {
        self.backgroundViewConfigure = backgroundViewConfigure
        self.contentViewConfigure = nil
    }
    
    init() {
        self.backgroundViewConfigure = FunalFloorBackagroundViewConfigure()
        self.contentViewConfigure = nil
    }
}
