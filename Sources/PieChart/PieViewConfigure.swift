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
    
    let displayTextConfigure: DisplayLabelConfigure?
    
    let pieSectorViewConfigure: PieSectorViewConfigure
    
    var isShowLabel: Bool {
        self.displayTextConfigure != nil
    }
    
    var isLeftSector: Bool {
        self.pieSectorViewConfigure.isLeftSector
    }
    
    init(startAngle: CGFloat, endAngle: CGFloat, backgroundColor: LiteChartDarkLightColor) {
        self.pieSectorViewConfigure = PieSectorViewConfigure(startAngle: startAngle, endAngle: endAngle, backgroundColor: backgroundColor)
        self.displayTextConfigure = nil
        
    }
    
    init(startAngle: CGFloat, endAngle: CGFloat, backgroundColor: LiteChartDarkLightColor, displayText: String, displayTextColor: LiteChartDarkLightColor, lineColor: LiteChartDarkLightColor = .init(lightUIColor: .black, darkUIColor: .white)) {
        self.pieSectorViewConfigure = PieSectorViewConfigure(startAngle: startAngle, endAngle: endAngle, backgroundColor: backgroundColor, lineColor: lineColor)
        let alignment: NSTextAlignment = self.pieSectorViewConfigure.isLeftSector ? .right : .left
        self.displayTextConfigure = DisplayLabelConfigure(contentString: displayText, contentColor: displayTextColor, textAlignment: alignment)
    }
    
    init() {
        self.pieSectorViewConfigure = PieSectorViewConfigure()
        self.displayTextConfigure = nil
    }
}
