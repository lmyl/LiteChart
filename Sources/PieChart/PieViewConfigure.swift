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
    
    let displayTextConfigure: DisplayLabelConfigure
    
    let pieSectorViewConfigure: PieSectorViewConfigure
    
    let isShowLabel: Bool
    
    var isLeftSector: Bool {
        self.pieSectorViewConfigure.isLeftSector
    }
    
    init(isShowLabel: Bool, pieSectorViewConfigure: PieSectorViewConfigure, displayTextConfigure: DisplayLabelConfigure = .emptyConfigure) {
        self.isShowLabel = isShowLabel
        self.displayTextConfigure = displayTextConfigure
        self.pieSectorViewConfigure = pieSectorViewConfigure
    }
    
    private init() {
        self.pieSectorViewConfigure = PieSectorViewConfigure.emptyConfigure
        self.displayTextConfigure = .emptyConfigure
        self.isShowLabel = false
    }
}

extension PieViewConfigure {
    static let emptyConfigure = PieViewConfigure()
}
