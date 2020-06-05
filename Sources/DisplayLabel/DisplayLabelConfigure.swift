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
    
    init(contentString: String, contentColor: LiteChartDarkLightColor) {
        self.contentColor = contentColor
        self.contentString = contentString
    }
    
}
