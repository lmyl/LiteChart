//
//  AxisViewLayerDelegate.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/9/29.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation
import UIKit

class AxisViewBorderMaskLayerDelegate: NSObject, CALayerDelegate {
    
    private let borderStyle: [AxisViewBorderStyle]
    private let borderColor: LiteChartDarkLightColor
    private let borderWidth: CGFloat
    
    init(borderColor: LiteChartDarkLightColor, borderStyle: [AxisViewBorderStyle], borderWidth: CGFloat) {
        self.borderStyle = borderStyle
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        super.init()
    }

    func display(_ layer: CALayer) {
        layer.contents = nil
        LiteChartDispatchQueue.asyncDrawQueue.async {
            layer.contentsScale = UIScreen.main.scale
            if let superlayer = layer.superlayer {
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                layer.frame = superlayer.bounds
                CATransaction.commit()
            }
            UIGraphicsBeginImageContextWithOptions(layer.bounds.size, false, layer.contentsScale)
            let context = UIGraphicsGetCurrentContext()
            guard let ctx = context else {
                return
            }
            ctx.saveGState()
            self.drawBorder(layer: layer, in: ctx)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            ctx.restoreGState()
            UIGraphicsEndImageContext()
            LiteChartDispatchQueue.asyncDrawDoneQueue.async {
                layer.contents = image?.cgImage
            }
        }
    }
    
    private func drawBorder(layer: CALayer, in context: CGContext) {

        context.setLineCap(.round)
        context.setAllowsAntialiasing(true)
        context.setShouldAntialias(true)
        context.setFillColor(UIColor.black.cgColor)
        let allRect = layer.bounds
        let remain = CGRect(x: self.borderWidth, y: self.borderWidth, width: allRect.width - 2 * self.borderWidth, height: allRect.height - 2 * self.borderWidth)
        context.fill(remain)
        context.setStrokeColor(UIColor.black.cgColor)
        context.setLineWidth(self.borderWidth)
        
        let path = UIBezierPath()
        let rect = layer.bounds
        let topLeft = rect.origin
        let topRight = CGPoint(x: rect.origin.x + rect.width, y: rect.origin.y)
        let bottomLeft = CGPoint(x: rect.origin.x, y: rect.origin.y + rect.height)
        let bottomRight = CGPoint(x: rect.origin.x + rect.width, y: rect.origin.y + rect.height)
        for border in self.borderStyle {
            switch border {
            case .top:
                path.move(to: topLeft)
                path.addLine(to: topRight)
            case .bottom:
                path.move(to: bottomLeft)
                path.addLine(to: bottomRight)
            case .left:
                path.move(to: topLeft)
                path.addLine(to: bottomLeft)
            case .right:
                path.move(to: topRight)
                path.addLine(to: bottomRight)
            }
        }
        context.addPath(path.cgPath)
        context.drawPath(using: .stroke)
    }
}
