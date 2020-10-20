//
//  RadarDataView.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/22.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit

class RadarDataView: UIView {
    private let configure: RadarDataViewConfigure
    
    private var insideAnimationStatus: LiteChartAnimationStatus = .ready
    private let scanAnimationKey = "ScanKey"
    
    init(configure: RadarDataViewConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
    }
    
    required init?(coder: NSCoder) {
        self.configure = RadarDataViewConfigure.emptyConfigure
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
            let edeges = self.configure.points.count
            guard edeges >= 3 else {
                return
            }
            let rect = layer.bounds
            let context = UIGraphicsGetCurrentContext()
            context?.saveGState()
            context?.setAllowsAntialiasing(true)
            context?.setShouldAntialias(true)
            
            context?.setLineCap(.round)
            context?.setLineJoin(.round)
            context?.setLineWidth(1)
            context?.setStrokeColor(self.configure.color.color.cgColor)
            
            let radius = min(rect.width, rect.height) / 2
            let centerX = rect.origin.x + rect.width / 2
            let centerY = rect.origin.y + rect.height / 2
            let center = CGPoint(x: centerX, y: centerY)
            let points = self.computeVertexLocation(for: center, radius: radius, points: self.configure.points)
            
            context?.addLines(between: points)
            context?.closePath()
            let color = self.configure.color.color.withAlphaComponent(0.5)
            context?.setFillColor(color.cgColor)
            
            context?.drawPath(using: .fillStroke)
            
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
    
    private func computeVertexLocation(for center: CGPoint, radius: CGFloat, points: [CGFloat]) -> [CGPoint] {
        let angles = self.configure.angleOfPoints
        guard angles.count == points.count else {
            fatalError("框架内部数据处理错误，不给予拯救")
        }
        
        var result: [CGPoint] = []
        for (index, point) in points.enumerated() {
            var length = point
            if point > 1 {
                length = 1
            } else if point < 0 {
                length = 0
            }
            let realRadius = radius * length
            let realPoint = self.computePointInCircle(for: center, radius: realRadius, angle: CGFloat(angles[index]))
            result.append(realPoint)
        }
        return result
    }
}

extension RadarDataView: LiteChartAnimatable {
    func startAnimation(animation: LiteChartAnimationInterface) {
        guard self.insideAnimationStatus == .cancel || self.insideAnimationStatus == .ready || self.insideAnimationStatus == .finish else {
            return
        }
        guard case .base(_) = animation.animationType else {
            return
        }
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.layer.bounds
        maskLayer.strokeColor = UIColor.black.cgColor
        maskLayer.fillColor = UIColor.clear.cgColor
        let center = CGPoint(x: self.layer.bounds.width / 2, y: self.layer.bounds.height / 2)
        let radius = min(self.layer.bounds.width, self.layer.bounds.height) / 2
        maskLayer.lineWidth = radius
        let storkeRadius = radius / 2
        maskLayer.path = UIBezierPath(arcCenter: center, radius: storkeRadius, startAngle: 0, endAngle: 2 * CGFloat(Double.pi), clockwise: true).cgPath
        
        let current = CACurrentMediaTime()
        let animationKey = "strokeEnd"
        let scanAnimation = animation.animationType.quickAnimation(keyPath: animationKey)
        scanAnimation.beginTime = current + animation.delay
        scanAnimation.timingFunction = animation.timingFunction
        scanAnimation.fillMode = animation.fillModel
        scanAnimation.fromValue = 0
        scanAnimation.toValue = 1
        scanAnimation.delegate = self
        
        layer.syncTimeSystemToFather()
        layer.mask = maskLayer
        maskLayer.add(scanAnimation, forKey: scanAnimationKey)
        
        self.insideAnimationStatus = .running
    }
    
    func stopAnimation() {
        guard self.insideAnimationStatus == .running || self.insideAnimationStatus == .pause else {
            return
        }
        self.layer.mask?.removeAnimation(forKey: scanAnimationKey)
        self.layer.syncTimeSystemToFather()
        self.insideAnimationStatus = .cancel
    }
    
    func pauseAnimation() {
        guard self.insideAnimationStatus == .running else {
            return
        }
        let current = CACurrentMediaTime()
        let pauseTime = (current - self.layer.beginTime) * Double(self.layer.speed) + self.layer.timeOffset
        self.layer.speed = 0
        self.layer.timeOffset = pauseTime
        self.insideAnimationStatus = .pause
    }
    
    func continueAnimation() {
        guard self.insideAnimationStatus == .pause else {
            return
        }
        let current = CACurrentMediaTime()
        self.layer.beginTime = current
        self.layer.speed = 1
        self.insideAnimationStatus = .running
    }
    
    var animationStatus: LiteChartAnimationStatus {
        self.insideAnimationStatus
    }
    
    
}

extension RadarDataView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.layer.mask = nil
        if self.insideAnimationStatus != .cancel {
            self.insideAnimationStatus = .finish
        }
    }
}
