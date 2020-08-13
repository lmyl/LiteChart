//
//  AxisView.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/10.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit

class AxisView: UIView {
    private let configure: AxisViewConfigure
    private var borderLayer: CAShapeLayer?
        
    init(configure: AxisViewConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        self.configure = AxisViewConfigure.emptyConfigure
        super.init(coder: coder)
        self.backgroundColor = .clear
    }
    
    override func draw(_ layer: CALayer, in ctx: CGContext) {
        super.draw(layer, in: ctx)
        let drawShapeLayer = CAShapeLayer()
        drawShapeLayer.lineCap = .round
        drawShapeLayer.strokeColor = self.configure.borderColor.color.cgColor
        drawShapeLayer.lineWidth = 1
        drawShapeLayer.allowsEdgeAntialiasing = true
        let path = UIBezierPath()
        let rect = layer.bounds
        let topLeft = rect.origin
        let topRight = CGPoint(x: rect.origin.x + rect.width, y: rect.origin.y)
        let bottomLeft = CGPoint(x: rect.origin.x, y: rect.origin.y + rect.height)
        let bottomRight = CGPoint(x: rect.origin.x + rect.width, y: rect.origin.y + rect.height)
        for border in self.configure.borderStyle {
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
        drawShapeLayer.frame = layer.bounds
        drawShapeLayer.path = path.cgPath
        layer.addSublayer(drawShapeLayer)
        self.borderLayer = drawShapeLayer
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setAllowsAntialiasing(true)
        context?.setShouldAntialias(true)
        context?.setLineWidth(1)
        context?.setLineCap(.round)
        
        context?.setLineDash(phase: 0, lengths: [])
        let originX: CGFloat
        if self.configure.originPoint.x < 0 {
            originX = 0
        } else if self.configure.originPoint.x > 1 {
            originX = 1
        } else {
            originX = self.configure.originPoint.x
        }
        let originY: CGFloat
        if self.configure.originPoint.y < 0 {
            originY = 1
        } else if self.configure.originPoint.y > 1 {
            originY = 0
        } else {
            originY = 1 - self.configure.originPoint.y
        }
        let originPoint = CGPoint(x: originX, y: originY)
        let horAxisLineLeftPoint = CGPoint(x: rect.origin.x, y: rect.origin.y + rect.height * originPoint.y)
        let horAxisLineRightPoint = CGPoint(x: rect.origin.x + rect.width, y: rect.origin.y + rect.height * originPoint.y)
        let verAxisLineTopPoint = CGPoint(x: rect.origin.x + rect.width * originPoint.x, y: rect.origin.y)
        let verAxisLineBottomPoint = CGPoint(x: rect.origin.x + rect.width * originPoint.x, y: rect.origin.y + rect.height)
        context?.setStrokeColor(self.configure.axisColor.color.cgColor)
        if self.configure.isShowXAxis {
            context?.addLines(between: [horAxisLineLeftPoint, horAxisLineRightPoint])
        }
        if self.configure.isShowYAxis {
            context?.addLines(between: [verAxisLineTopPoint, verAxisLineBottomPoint])
        }
        context?.drawPath(using: .stroke)
        
        for verDiv in self.configure.verticalDividingPoints {
            let offset: CGFloat
            if verDiv.location < 0 {
                offset = 1
            } else if verDiv.location > 1 {
                offset = 0
            } else {
                offset = 1 - verDiv.location
            }
            let horAxisLineLeftPoint = CGPoint(x: rect.origin.x, y: rect.origin.y + rect.height * offset)
            let horAxisLineRightPoint = CGPoint(x: rect.origin.x + rect.width, y: rect.origin.y + rect.height * offset)
            if self.configure.isShowXAxis && offset == originPoint.y {
                continue
            }
            context?.setStrokeColor(verDiv.dividingLineColor.color.cgColor)
            switch verDiv.dividingLineStyle {
            case .solid:
                context?.setLineDash(phase: 0, lengths: [])
                context?.addLines(between: [horAxisLineLeftPoint, horAxisLineRightPoint])
            case .dotted:
                context?.setLineDash(phase: 1, lengths: [6, 3])
                context?.addLines(between: [horAxisLineLeftPoint, horAxisLineRightPoint])
            case .segment:
                var length = min(rect.width, rect.height) / 20
                length = min(length, 4)
                let horSegmentEndPoint = CGPoint(x: rect.origin.x + length, y: rect.origin.y + rect.height * offset)
                context?.setLineDash(phase: 0, lengths: [])
                context?.addLines(between: [horAxisLineLeftPoint, horSegmentEndPoint])
            }
            context?.drawPath(using: .stroke)
        }
    
        for verDiv in self.configure.horizontalDividingPoints {
            let offset: CGFloat
            if verDiv.location < 0 {
                offset = 0
            } else if verDiv.location > 1 {
                offset = 1
            } else {
                offset = verDiv.location
            }
            let verAxisLineTopPoint = CGPoint(x: rect.origin.x + rect.width * offset, y: rect.origin.y)
            let verAxisLineBottomPoint = CGPoint(x: rect.origin.x + rect.width * offset, y: rect.origin.y + rect.height)
            if self.configure.isShowYAxis && offset == originPoint.x {
                continue
            }
            context?.setStrokeColor(verDiv.dividingLineColor.color.cgColor)
            switch verDiv.dividingLineStyle {
            case .solid:
                context?.setLineDash(phase: 0, lengths: [])
                context?.addLines(between: [verAxisLineTopPoint, verAxisLineBottomPoint])
            case .dotted:
                context?.setLineDash(phase: 1, lengths: [6, 3])
                context?.addLines(between: [verAxisLineTopPoint, verAxisLineBottomPoint])
            case .segment:
                var length = min(rect.width, rect.height) / 20
                length = min(length, 4)
                let verSegmentEndPoint = CGPoint(x: rect.origin.x + rect.width * offset, y: rect.origin.y + rect.height - length)
                context?.setLineDash(phase: 0, lengths: [])
                context?.addLines(between: [verAxisLineBottomPoint, verSegmentEndPoint])
            }
            context?.drawPath(using: .stroke)
        }
        
    }
}
