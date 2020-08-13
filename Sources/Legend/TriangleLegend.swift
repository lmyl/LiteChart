//
//  TriangleLegend.swift
//  LiteChart
//
//  Created by huangxiaohui on 2020/6/16.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit

class TriangleLegend: UIView {
    
    private var color: LiteChartDarkLightColor
    
    init(color: LiteChartDarkLightColor) {
        self.color = color
        super.init(frame: CGRect())
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        self.color = .init(lightUIColor: .yellow, darkUIColor: .blue)
        super.init(coder:coder)
        self.backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setNeedsDisplay()
    }
    
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setShouldAntialias(true)
        context?.setAllowsAntialiasing(true)
        context?.clear(rect)
        let width = rect.width
        let height = rect.height
        let baseLength = min(width, height)
        let topX = rect.origin.x + rect.width / 2
        let topY = rect.origin.y + (rect.height - baseLength) / 2
        let topPoint = CGPoint(x: topX, y: topY)
        let leftX = topX - baseLength / 2
        let rightX = topX + baseLength / 2
        let bottomY = topY + baseLength
        let leftPoint = CGPoint(x: leftX, y: bottomY)
        let rightPoint = CGPoint(x: rightX, y: bottomY)
        context?.addLines(between: [topPoint, leftPoint, rightPoint])
        context?.setFillColor(self.color.color.cgColor)
        context?.drawPath(using: .fill)
        
    }
}
