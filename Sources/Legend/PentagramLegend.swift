//
//  PentagonLegend.swift
//  LiteChart
//
//  Created by huangxiaohui on 2020/6/16.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit

class PentagramLegend: UIView { 
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setAllowsAntialiasing(true)
        context?.setAllowsAntialiasing(true)
        context?.clear(rect)
        let width = rect.width
        let height = rect.height
        let radius = min(width, height) / 2
        let centerX = rect.origin.x + rect.width / 2
        let centerY = rect.origin.y + radius + (rect.height - 2 * radius) / 2
        let topPoint = CGPoint(x: centerX, y: centerY - radius)
        
        let midY = centerY - radius * sinValue(of: 18)
        let midLeftX = centerX - radius * cosValue(of: 18)
        let midRightX = centerX + radius * cosValue(of: 18)
        let midLeftPoint = CGPoint(x: midLeftX, y: midY)
        let midRightPoint = CGPoint(x: midRightX, y: midY)
        
        let btmY = centerY + radius * cosValue(of: 36)
        let btmLeftX = centerX - radius * sinValue(of: 36)
        let btmRightX = centerX + radius * sinValue(of: 36)
        let btmLeftPoint = CGPoint(x: btmLeftX, y: btmY)
        let btmRightPoint = CGPoint(x: btmRightX, y: btmY)
        
        context?.move(to: topPoint)
        context?.addLine(to: btmLeftPoint)
        context?.addLine(to: midRightPoint)
        context?.addLine(to: midLeftPoint)
        context?.addLine(to: btmRightPoint)
        context?.addLine(to: topPoint)
        context?.setFillColor(self.color.color.cgColor)
        context?.drawPath(using: .fill)
        
    }
    
    private func cosValue(of angle: Double) -> CGFloat {
        return CGFloat(cos(Double.pi / 180 * angle))
    }
    
    private func sinValue(of angle: Double) -> CGFloat {
        return CGFloat(sin(Double.pi / 180 * angle))
    }
}
