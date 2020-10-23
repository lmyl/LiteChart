//
//  PieLineLayerDelegate.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/10/23.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit

class PieLineViewLayerDelegate: NSObject, CALayerDelegate {
    let configure: PieLineViewConfigure
    
    init(configure: PieLineViewConfigure) {
        self.configure = configure
    }
    
    private var pointLocationCancel: [Int : CGPoint] = [:]
    
    func draw(_ layer: CALayer, in ctx: CGContext) {
        layer.contents = UIScreen.main.scale
        guard let lineLayer = layer as? CAShapeLayerWithTag else {
            return
        }
        guard self.configure.lineColors.count == self.configure.pieNumber else {
            return
        }
        lineLayer.lineWidth = 1
        lineLayer.lineCap = .round
        lineLayer.allowsEdgeAntialiasing = true
        lineLayer.fillColor = UIColor.clear.cgColor
        let center = CGPoint(x: layer.bounds.width / 2, y: layer.bounds.height / 2)
        var radius = min(layer.bounds.width , layer.bounds.height) / 2
        let polylineSegmentLength = min(layer.bounds.width, layer.bounds.width) / 12
        radius = radius - polylineSegmentLength
        let index = lineLayer.tag
        let currentPieSectorConfigure = self.configure.pieViewConfigure.pieSectorViewConfigures[index]
        let lineAngle = currentPieSectorConfigure.averageAngle
        lineLayer.strokeColor = self.configure.lineColors[index].color.cgColor
        let startPoint = self.computePointInCircle(for: center, radius: radius, angle: lineAngle)
        let firstSegmentLineLength = polylineSegmentLength / 2
        let secondSegmentLineLength = polylineSegmentLength - firstSegmentLineLength
        let secondPoint = self.computePointInCircle(for: startPoint, radius: firstSegmentLineLength, angle: lineAngle)
        let endPointX: CGFloat
        if currentPieSectorConfigure.isLeftSector {
            endPointX = secondPoint.x - secondSegmentLineLength
        } else {
            endPointX = secondPoint.x + secondSegmentLineLength
        }
        let endPoint = CGPoint(x: endPointX, y: secondPoint.y)
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: secondPoint)
        path.addLine(to: endPoint)
        lineLayer.path = path.cgPath
        let newPoint = lineLayer.convert(endPoint, to: layer.superlayer)
        self.postLocation(for: newPoint, with: index, by: layer)
    }
    
    private func postLocation(for point: CGPoint, with index: Int, by: CALayer) {
        if let existLocation = self.pointLocationCancel[index], existLocation == point {
            return
        }
        guard let superView = by.superlayer?.delegate as? PieLineView else {
            return
        }
        self.pointLocationCancel[index] = point
        NotificationCenter.default.post(name: .didComputeLabelLocationForPie, object: superView, userInfo: [superView.notificationKey : (index, point)])
    }
    
    
    private func computeRadian(for angle: CGFloat) -> CGFloat {
        angle * CGFloat(Double.pi) / 180
    }
    
    private func computePointInCircle(for center: CGPoint, radius: CGFloat, angle: CGFloat) -> CGPoint {
        let radian = computeRadian(for: angle)
        let pointX = radius * cos(radian)
        let pointY = radius * sin(radian)
        let newPointX = center.x + pointX
        let newPointY = center.y + pointY
        return CGPoint(x: newPointX, y: newPointY)
    }
    
}
