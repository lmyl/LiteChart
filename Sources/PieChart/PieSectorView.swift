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
    
    let notificationInfoKey = "lineEndPoint"
    
    private var polylineLineEndPoint: CGPoint? {
        didSet {
            if oldValue != polylineLineEndPoint, let point = polylineLineEndPoint {
                NotificationCenter.default.post(name: .didComputeLabelLocationForPie, object: self, userInfo: [self.notificationInfoKey: point])
            }
        }
    }
    
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
            let radius: CGFloat
            if self.configure.isShowLine {
                let tempRadius = min(rect.width, rect.height) / 2
                let polylineSegmentLength = tempRadius / 6
                radius = tempRadius - polylineSegmentLength
            } else {
                radius = min(rect.width, rect.height) / 2
            }
            context?.move(to: center)
            context?.addArc(center: center, radius: radius / 2, startAngle: self.computeRadian(for: self.configure.startAngle), endAngle: self.computeRadian(for: self.configure.endAngle), clockwise: false)
            context?.closePath()
            context?.move(to: center)
            context?.addArc(center: center, radius: radius, startAngle: self.computeRadian(for: self.configure.startAngle), endAngle: self.computeRadian(for: self.configure.endAngle), clockwise: false)
            context?.closePath()
            context?.setFillColor(self.configure.backgroundColor.color.cgColor)
            context?.drawPath(using: .eoFill)
            if self.configure.isShowLine {
                context?.setLineWidth(1)
                context?.setLineCap(.round)
                context?.setStrokeColor(self.configure.lineColor.color.cgColor)
                let lineAngle = self.configure.averageAngle
                let startPoint = self.computePointInCircle(for: center, radius: radius, angle: lineAngle)
                context?.move(to: startPoint)
                let polylineLength = min(rect.width, rect.height) / 2 - radius
                let firstSegmentLineLength = polylineLength / 2
                let secondSegmentLineLength = polylineLength - firstSegmentLineLength
                let secondPoint = self.computePointInCircle(for: startPoint, radius: firstSegmentLineLength, angle: lineAngle)
                let endPointX: CGFloat
                if self.configure.isLeftSector {
                    endPointX = secondPoint.x - secondSegmentLineLength
                } else {
                    endPointX = secondPoint.x + secondSegmentLineLength
                }
                let endPoint = CGPoint(x: endPointX, y: secondPoint.y)
                context?.addLines(between: [startPoint, secondPoint, endPoint])
                context?.drawPath(using: .stroke)
                self.polylineLineEndPoint = endPoint
            }
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
    
    private func computePointInCircle(for center: CGPoint, radius: CGFloat, angle: CGFloat) -> CGPoint {
        let radian = computeRadian(for: angle)
        let pointX = radius * cos(radian)
        let pointY = radius * sin(radian)
        let newPointX = center.x + pointX
        let newPointY = center.y + pointY
        return CGPoint(x: newPointX, y: newPointY)
    }
}
