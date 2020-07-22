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
    
    var isShowLabel: Bool
    
    var isLeftSector: Bool {
        self.pieSectorViewConfigure.isLeftSector
    }
    
    init(startAngle: CGFloat, endAngle: CGFloat, backgroundColor: LiteChartDarkLightColor, isShowLable: Bool, textConfigure: DisplayLabelConfigure = .emptyConfigure, lineColor: LiteChartDarkLightColor = .init(lightUIColor: .black, darkUIColor: .white)) {
        self.pieSectorViewConfigure = PieSectorViewConfigure(startAngle: startAngle, endAngle: endAngle, backgroundColor: backgroundColor, isShowLine: isShowLable, lineColor: lineColor)
        let alignment: NSTextAlignment = self.pieSectorViewConfigure.isLeftSector ? .right : .left
        self.displayTextConfigure = DisplayLabelConfigure(contentString: textConfigure.contentString, contentColor: textConfigure.contentColor, textAlignment: alignment)
        self.isShowLabel = isShowLable
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
