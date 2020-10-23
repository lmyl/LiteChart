//
//  PieValueViewConfigure.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/10/23.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation

struct PieValueViewConfigure {
    let pieLineViewConfigure: PieLineViewConfigure
    let displayTextConfigures: [DisplayLabelConfigure]
    let isShowLable: Bool
    
    var pieNumber: Int {
        pieLineViewConfigure.pieNumber
    }
}

extension PieValueViewConfigure {
    private init() {
        self.pieLineViewConfigure = .emptyCongfigure
        self.displayTextConfigures = []
        self.isShowLable = false
    }
    
    static let emptyConfigure = PieValueViewConfigure()
}
