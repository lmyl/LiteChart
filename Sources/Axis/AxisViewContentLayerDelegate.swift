//
//  AxisViewContentLayerDelegate.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/9/29.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation
import UIKit

class AxisViewContentLayerDelegate: NSObject, CALayerDelegate {
    private let verticalDividingPoints : [AxisDividingLineConfigure]
    
    private let horizontalDividingPoints: [AxisDividingLineConfigure]
    
    private let originPoint: CGPoint
    
    private let axisColor: LiteChartDarkLightColor
    
    private let isShowXAxis: Bool
    
    private let isShowYAxis: Bool
    
    init(verticalDividingPoints : [AxisDividingLineConfigure], horizontalDividingPoints: [AxisDividingLineConfigure], originPoint: CGPoint, axisColor: LiteChartDarkLightColor, isShowXAxis: Bool, isShowYAxis: Bool) {
        self.verticalDividingPoints = verticalDividingPoints
        self.horizontalDividingPoints = horizontalDividingPoints
        self.originPoint = originPoint
        self.axisColor = axisColor
        self.isShowXAxis = isShowXAxis
        self.isShowYAxis = isShowYAxis
        super.init()
    }
    
    func display(_ layer: CALayer) {
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
            self.drawContent(layer: layer, in: ctx)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            ctx.restoreGState()
            UIGraphicsEndImageContext()
            LiteChartDispatchQueue.asyncDrawDoneQueue.async {
                layer.contents = image?.cgImage
            }
        }
    }
    
    private func drawContent(layer: CALayer, in context: CGContext) {
        let rect = layer.bounds
        context.saveGState()
        context.setAllowsAntialiasing(true)
        context.setShouldAntialias(true)
        context.setLineWidth(1)
        context.setLineCap(.round)
        
        context.setLineDash(phase: 0, lengths: [])
        let originX: CGFloat
        if self.originPoint.x < 0 {
            originX = 0
        } else if self.originPoint.x > 1 {
            originX = 1
        } else {
            originX = self.originPoint.x
        }
        let originY: CGFloat
        if self.originPoint.y < 0 {
            originY = 1
        } else if self.originPoint.y > 1 {
            originY = 0
        } else {
            originY = 1 - self.originPoint.y
        }
        let originPoint = CGPoint(x: originX, y: originY)
        let horAxisLineLeftPoint = CGPoint(x: rect.origin.x, y: rect.origin.y + rect.height * originPoint.y)
        let horAxisLineRightPoint = CGPoint(x: rect.origin.x + rect.width, y: rect.origin.y + rect.height * originPoint.y)
        let verAxisLineTopPoint = CGPoint(x: rect.origin.x + rect.width * originPoint.x, y: rect.origin.y)
        let verAxisLineBottomPoint = CGPoint(x: rect.origin.x + rect.width * originPoint.x, y: rect.origin.y + rect.height)
        context.setStrokeColor(self.axisColor.color.cgColor)
        if self.isShowXAxis {
            context.addLines(between: [horAxisLineLeftPoint, horAxisLineRightPoint])
        }
        if self.isShowYAxis {
            context.addLines(between: [verAxisLineTopPoint, verAxisLineBottomPoint])
        }
        context.drawPath(using: .stroke)
        
        for verDiv in self.verticalDividingPoints {
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
            if self.isShowXAxis && offset == originPoint.y {
                continue
            }
            context.setStrokeColor(verDiv.dividingLineColor.color.cgColor)
            switch verDiv.dividingLineStyle {
            case .solid:
                context.setLineDash(phase: 0, lengths: [])
                context.addLines(between: [horAxisLineLeftPoint, horAxisLineRightPoint])
            case .dotted:
                context.setLineDash(phase: 1, lengths: [6, 3])
                context.addLines(between: [horAxisLineLeftPoint, horAxisLineRightPoint])
            case .segment:
                var length = min(rect.width, rect.height) / 20
                length = min(length, 4)
                let horSegmentEndPoint = CGPoint(x: rect.origin.x + length, y: rect.origin.y + rect.height * offset)
                context.setLineDash(phase: 0, lengths: [])
                context.addLines(between: [horAxisLineLeftPoint, horSegmentEndPoint])
            }
            context.drawPath(using: .stroke)
        }
    
        for verDiv in self.horizontalDividingPoints {
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
            if self.isShowYAxis && offset == originPoint.x {
                continue
            }
            context.setStrokeColor(verDiv.dividingLineColor.color.cgColor)
            switch verDiv.dividingLineStyle {
            case .solid:
                context.setLineDash(phase: 0, lengths: [])
                context.addLines(between: [verAxisLineTopPoint, verAxisLineBottomPoint])
            case .dotted:
                context.setLineDash(phase: 1, lengths: [6, 3])
                context.addLines(between: [verAxisLineTopPoint, verAxisLineBottomPoint])
            case .segment:
                var length = min(rect.width, rect.height) / 20
                length = min(length, 4)
                let verSegmentEndPoint = CGPoint(x: rect.origin.x + rect.width * offset, y: rect.origin.y + rect.height - length)
                context.setLineDash(phase: 0, lengths: [])
                context.addLines(between: [verAxisLineBottomPoint, verSegmentEndPoint])
            }
            context.drawPath(using: .stroke)
        }
    }
}
