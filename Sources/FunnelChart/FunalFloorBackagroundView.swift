//
//  FunalFloorBackagroundView.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/5.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit

class FunalFloorBackagroundView: UIView {
    
    var configure: FunalFloorBackagroundViewConfigure
    
    init(configure: FunalFloorBackagroundViewConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        self.configure = FunalFloorBackagroundViewConfigure()
        super.init(coder: coder)
        self.backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setAllowsAntialiasing(true)
        context?.setShouldAntialias(true)
        let topLeft = rect.width * (1 - self.configure.topPercent) / 2
        let topStartX = rect.origin.x + topLeft
        let topEndX = rect.origin.x + rect.width - topLeft
        let bottomLeft = rect.width * (1 - self.configure.bottomPercent) / 2
        let bottomStartX = rect.origin.x + bottomLeft
        let bottomEndX = rect.origin.x + rect.width - bottomLeft
        let topLeftPoint = CGPoint(x: topStartX, y: rect.origin.y)
        let topRightPoint = CGPoint(x: topEndX, y: rect.origin.y)
        let bottomLeftPoint = CGPoint(x: bottomStartX, y: rect.origin.y + rect.height)
        let bottomRightPoint = CGPoint(x: bottomEndX, y: rect.origin.y + rect.height)
        context?.addLines(between: [topLeftPoint, topRightPoint, bottomRightPoint, bottomLeftPoint, topLeftPoint])
        context?.setFillColor(self.configure.color.color.cgColor)
        context?.drawPath(using: .fill)
    }
    
}
