//
//  PieSectorView.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/8.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit

class PieSectorView: UIView {
    let configure: PieSectorViewConfigure
    
    let notificationInfoKey = "lineEndPoint"
    
    private var polylineLineEndPoint: CGPoint? {
        didSet {
            if oldValue != polylineLineEndPoint, let point = polylineLineEndPoint {
                NotificationCenter.default.post(name: .didComputeLabelLocation, object: self, userInfo: [self.notificationInfoKey: point])
            }
        }
    }
    
    init(configure: PieSectorViewConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        self.configure = PieSectorViewConfigure()
        super.init(coder: coder)
        self.backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setAllowsAntialiasing(true)
        context?.setShouldAntialias(true)
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let radius: CGFloat
        if self.configure.lineColor != nil {
            let tempRadius = min(rect.width, rect.height) / 2
            let polylineSegmentLength = min(tempRadius / 8, 20)
            radius = tempRadius - polylineSegmentLength
        } else {
            radius = min(rect.width, rect.height) / 2
        }
        context?.move(to: center)
        context?.addArc(center: center, radius: radius, startAngle: computeRadian(for: self.configure.startAngle), endAngle: computeRadian(for: self.configure.endAngle), clockwise: false)
        context?.closePath()
        context?.setFillColor(self.configure.backgroundColor.color.cgColor)
        context?.drawPath(using: .fill)
        if let lineColor = self.configure.lineColor {
            context?.setLineWidth(1)
            context?.setLineCap(.round)
            context?.setStrokeColor(lineColor.color.cgColor)
            let lineAngle = self.configure.averageAngle
            let startPoint = computePointInCircle(for: center, radius: radius, angle: lineAngle)
            context?.move(to: startPoint)
            let polylineLength = min(rect.width, rect.height) / 2 - radius
            let firstSegmentLineLength = polylineLength / 2
            let secondSegmentLineLength = polylineLength - firstSegmentLineLength
            let secondPoint = computePointInCircle(for: startPoint, radius: firstSegmentLineLength, angle: lineAngle)
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
