//
//  CircleLegend.swift
//  LiteChart
//
//  Created by huangxiaohui on 2020/6/16.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit

class CircleLegend: UIView {
    
    private var color: LiteChartDarkLightColor
    
    init(color: LiteChartDarkLightColor) {
        self.color = color
        super.init(frame: CGRect())
    }
    
    required init?(coder: NSCoder) {
        self.color = .init(lightUIColor: .yellow, darkUIColor: .blue)
        super.init(coder:coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.setNeedsDisplay()
    }
    
    override func display(_ layer: CALayer) {
        LiteChartDispatchQueue.asyncDrawQueue.async {
            UIGraphicsBeginImageContextWithOptions(layer.bounds.size, false, layer.contentsScale)
            let rect = layer.bounds
            let context = UIGraphicsGetCurrentContext()
            context?.setShouldAntialias(true)
            context?.setAllowsAntialiasing(true)
            context?.clear(rect)
            let width = rect.width
            let height = rect.height
            let radius = min(width, height) / 2
            let centerX = rect.origin.x + rect.width / 2
            let centerY = rect.origin.y + radius + (rect.height - 2 * radius) / 2
            let centerPoint = CGPoint(x: centerX, y: centerY)
            context?.addArc(center: centerPoint, radius: radius, startAngle: 0, endAngle: 360, clockwise: false)
            context?.setFillColor(self.color.color.cgColor)
            context?.drawPath(using: .fill)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            LiteChartDispatchQueue.asyncDrawDoneQueue.async {
                layer.contents = image?.cgImage
            }
        }
    }
}
