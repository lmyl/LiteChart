//
//  PieSectorView.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/8.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit

class PieSectorView: UIView {
    private let configure: PieSectorViewConfigure
    
    init(configure: PieSectorViewConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
    }
    
    required init?(coder: NSCoder) {
        self.configure = PieSectorViewConfigure.emptyConfigure
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.setNeedsDisplay()
    }
    
    override func display(_ layer: CALayer) {
        LiteChartDispatchQueue.asyncDrawQueue.async {
            layer.contentsScale = UIScreen.main.scale
            UIGraphicsBeginImageContextWithOptions(layer.bounds.size, false, layer.contentsScale)
            let rect = layer.bounds
            let context = UIGraphicsGetCurrentContext()
            context?.saveGState()
            context?.setAllowsAntialiasing(true)
            context?.setShouldAntialias(true)
            context?.clear(rect)
            let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
            let radius = min(rect.width, rect.height) / 2
            context?.move(to: center)
            context?.addArc(center: center, radius: radius / 2, startAngle: self.computeRadian(for: self.configure.startAngle), endAngle: self.computeRadian(for: self.configure.endAngle), clockwise: false)
            context?.closePath()
            context?.move(to: center)
            context?.addArc(center: center, radius: radius, startAngle: self.computeRadian(for: self.configure.startAngle), endAngle: self.computeRadian(for: self.configure.endAngle), clockwise: false)
            context?.closePath()
            context?.setFillColor(self.configure.backgroundColor.color.cgColor)
            context?.drawPath(using: .eoFill)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            context?.restoreGState()
            UIGraphicsEndImageContext()
            LiteChartDispatchQueue.asyncDrawDoneQueue.async {
                layer.contents = image?.cgImage
            }
        }
    }
    
    private func computeRadian(for angle: CGFloat) -> CGFloat {
        angle * CGFloat(Double.pi) / 180
    }
}
