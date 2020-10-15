//
//  DisplayLabelConfigure.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/5.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit

struct DisplayLabelConfigure {
    
    var contentString: String
    var contentColor: LiteChartDarkLightColor
    var textAlignment: NSTextAlignment
    var textDirection: DisplayLabelTextDirection
    var syncIdentifier: DisplayLabelSyncIdentifier
    
    var syncCenterIdentifier: String {
        self.syncIdentifier.syncCenterIdentifier
    }
    
    init(contentString: String, contentColor: LiteChartDarkLightColor, textAlignment: NSTextAlignment = .center, textDirection: DisplayLabelTextDirection = .horizontal, syncIdentifier: DisplayLabelSyncIdentifier = .emptyIdentifier) {
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
        self.syncIdentifier = .emptyIdentifier
    }
}


extension DisplayLabelConfigure {
    static let emptyConfigure = DisplayLabelConfigure()
}
