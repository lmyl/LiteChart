//
//  DisplayLabelConfigure.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/5.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit

struct DisplayLabelConfigure {
    
    let contentString: String
    let contentColor: LiteChartDarkLightColor
    let textAlignment: NSTextAlignment
    let textDirection: DisplayLabelTextDirection
    let syncIdentifier: DisplayLabelSyncIdentifier
    
    init(contentString: String, contentColor: LiteChartDarkLightColor, textAlignment: NSTextAlignment = .center, textDirection: DisplayLabelTextDirection = .horizontal, syncIdentifier: DisplayLabelSyncIdentifier = .none) {
        self.contentColor = contentColor
        self.contentString = contentString
        self.textAlignment = textAlignment
        self.textDirection = textDirection
        self.syncIdentifier = syncIdentifier
    }
    
    private init() {
        self.contentColor = .init(lightUIColor: .black, darkUIColor: .white)
        self.contentString = ""
        self.textAlignment = .center
        self.textDirection = .horizontal
        self.syncIdentifier = .none
    }
}


extension DisplayLabelConfigure {
    static let emptyConfigure = DisplayLabelConfigure()
}
