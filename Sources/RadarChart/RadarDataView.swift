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
    
    private func computeRegularPolygonVertexAngle(for vertexNumbers: Int) -> [CGFloat] {
        guard vertexNumbers >= 1 else {
            return []
        }
        var result: [CGFloat] = []
        let insideAngle = 360 / Double(vertexNumbers)
        for index in 0 ..< vertexNumbers {
            let angle = Double(index) * insideAngle - 90
            result.append(CGFloat(angle))
        }
        
        return result
    }
    
    private func computeVertexLocation(for center: CGPoint, radius: CGFloat, points: [CGFloat]) -> [CGPoint] {
        let angles = self.computeRegularPolygonVertexAngle(for: points.count)
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
            let realPoint = self.computePointInCircle(for: center, radius: realRadius, angle: angles[index])
            result.append(realPoint)
        }
        return result
    }
}
