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
    
    init(contentString: String, contentColor: LiteChartDarkLightColor, textAlignment: NSTextAlignment = .center, textDirection: DisplayLabelTextDirection = .horizontal) {
        self.contentColor = contentColor
        self.contentString = contentString
        self.textAlignment = textAlignment
        self.textDirection = textDirection
    }
    
    private init() {
        self.contentColor = .init(lightUIColor: .black, darkUIColor: .white)
        self.contentString = ""
        self.textAlignment = .center
        self.textDirection = .horizontal
    }
}


extension DisplayLabelConfigure {
    static let emptyConfigure = DisplayLabelConfigure()
}
