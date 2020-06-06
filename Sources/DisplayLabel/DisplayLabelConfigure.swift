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
    
    init(contentString: String, contentColor: LiteChartDarkLightColor, textAlignment: NSTextAlignment) {
        self.contentColor = contentColor
        self.contentString = contentString
        self.textAlignment = textAlignment
    }
    
    init(contentString: String, contentColor: LiteChartDarkLightColor) {
        self.contentColor = contentColor
        self.contentString = contentString
        self.textAlignment = .center
    }
    
    init() {
        self.contentColor = .init(lightColor: .black)
        self.contentString = ""
        self.textAlignment = .center
    }
}
