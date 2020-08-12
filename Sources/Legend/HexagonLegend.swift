//
//  hexagonLegend.swift
//  LiteChart
//
//  Created by huangxiaohui on 2020/6/16.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit

class HexagonLegend: UIView { 
    
    private var color: LiteChartDarkLightColor
    
    init(color: LiteChartDarkLightColor) {
        self.color = color
        super.init(frame: CGRect())
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        self.color = .init(lightUIColor: .yellow, darkUIColor: .blue)
        super.init(coder: coder)
        self.backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setAllowsAntialiasing(true)
        context?.setAllowsAntialiasing(true)
        context?.clear(rect)
        let width = rect.width
        let height = rect.height
        let sideLength = min(width, height) / 2
        let topLeftX = rect.origin.x + (rect.width - sideLength) / 2
        let topRightX = topLeftX + sideLength
        let topY = rect.origin.y + (rect.height - sqrt(3) * sideLength) / 2
        let bottomY = topY + sqrt(3) * sideLength
        let topLeftPoint = CGPoint(x: topLeftX, y: topY)
        let topRightPoint = CGPoint(x: topRightX, y: topY)
        let btmLeftPoint = CGPoint(x: topLeftX, y: bottomY)
        let btmRightPoint = CGPoint(x: topRightX, y: bottomY)
        
        let midLeftX = topLeftX - sideLength / 2
        let midRightX = midLeftX + sideLength * 2
        let midY = topY + sqrt(3) * sideLength / 2
        let midLeftPoint = CGPoint(x: midLeftX, y: midY)
        let midRightPoint = CGPoint(x: midRightX, y: midY)
        
        context?.addLines(between: [topLeftPoint, midLeftPoint,btmLeftPoint, btmRightPoint, midRightPoint, topRightPoint])
        context?.setFillColor(self.color.color.cgColor)
        context?.drawPath(using: .fill)
       
    }
}
