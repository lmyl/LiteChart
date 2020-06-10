//
//  AxisView.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/10.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit

class AxisView: UIView {
    let configure: AxisViewConfigure
    
    init(configure: AxisViewConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        self.configure = AxisViewConfigure()
        super.init(coder: coder)
        self.backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setAllowsAntialiasing(true)
        context?.setShouldAntialias(true)
        context?.setLineWidth(1)
        context?.setLineCap(.round)
        
        for verDiv in self.configure.verticalDividingPoints {
            let offset: CGFloat
            if verDiv.location < 0 {
                offset = 0
            } else if verDiv.location > 1 {
                offset = 1
            } else {
                offset = verDiv.location
            }
            let horAxisLineLeftPoint = CGPoint(x: rect.origin.x, y: rect.origin.y + rect.height * offset)
            let horAxisLineRightPoint = CGPoint(x: rect.origin.x + rect.width, y: rect.origin.y + rect.height * offset)
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
            originY = 0
        } else if self.configure.originPoint.y > 1 {
            originY = 1
        } else {
            originY = self.configure.originPoint.y
        }
        let originPoint = CGPoint(x: originX, y: originY)
        let horAxisLineLeftPoint = CGPoint(x: rect.origin.x, y: rect.origin.y + rect.height * originPoint.y)
        let horAxisLineRightPoint = CGPoint(x: rect.origin.x + rect.width, y: rect.origin.y + rect.height * originPoint.y)
        let verAxisLineTopPoint = CGPoint(x: rect.origin.x + rect.width * originPoint.x, y: rect.origin.y)
        let verAxisLineBottomPoint = CGPoint(x: rect.origin.x + rect.width * originPoint.x, y: rect.origin.y + rect.height)
        context?.setStrokeColor(self.configure.axisColor.color.cgColor)
        context?.addLines(between: [horAxisLineLeftPoint, horAxisLineRightPoint])
        context?.addLines(between: [verAxisLineTopPoint, verAxisLineBottomPoint])
        context?.drawPath(using: .stroke)
    
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
        
        context?.setLineDash(phase: 0, lengths: [])
        context?.setStrokeColor(self.configure.borderColor.color.cgColor)
        let topLeft = rect.origin
        let topRight = CGPoint(x: rect.origin.x + rect.width, y: rect.origin.y)
        let bottomLeft = CGPoint(x: rect.origin.x, y: rect.origin.y + rect.height)
        let bottomRight = CGPoint(x: rect.origin.x + rect.width, y: rect.origin.y + rect.height)
        for border in self.configure.borderStyle {
            switch border {
            case .top:
                context?.addLines(between: [topLeft, topRight])
            case .bottom:
                context?.addLines(between: [bottomLeft, bottomRight])
            case .left:
                context?.addLines(between: [topLeft, bottomLeft])
            case .right:
                context?.addLines(between: [topRight, bottomRight])
            }
            context?.drawPath(using: .stroke)
        }
        
    }
}
