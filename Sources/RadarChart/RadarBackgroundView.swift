//
//  RadarBackgroundView.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/22.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit
import SnapKit

class RadarBackgroundView: UIView {
    private let configure: RadarBackgroundViewConfigure
    
    let notificationInfoKey = "radarEndPoint"
    
    private var targetPoints: [CGPoint] = [] {
        didSet {
            if targetPoints != oldValue {
                NotificationCenter.default.post(name: .didComputeLabelLocationForRadar, object: self, userInfo: [notificationInfoKey: targetPoints])
            }
        }
    }
    
    init(configure: RadarBackgroundViewConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
    }
    
    required init?(coder: NSCoder) {
        self.configure = RadarBackgroundViewConfigure.emptyConfigure
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.setNeedsDisplay()
    }
    
    private var angleOfPoints: [Double] {
        self.configure.angleOfPoints
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
            context?.setStrokeColor(self.configure.radarLineColor.color.cgColor)
            context?.setLineCap(.round)
            context?.setLineJoin(.round)
            context?.setLineWidth(1)
            
            let radius = min(rect.width, rect.height) / 2
            let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
            let vertexs = self.computeVertexsLocation(for: center, radius: Double(radius), radarLayerCount: self.configure.radarLayerCount)
            
            for index in (0 ..< self.configure.radarLayerCount).reversed() {
                context?.addLines(between: vertexs[index])
                context?.closePath()
                if index % 2 == 0 {
                    context?.setFillColor(self.configure.radarLightColor.color.cgColor)
                } else {
                    context?.setFillColor(self.configure.radarUnlightColor.color.cgColor)
                }
                context?.drawPath(using: .fillStroke)
            }
            if let lastVertexs = vertexs.last {
                for index in 0 ..< lastVertexs.count {
                    context?.addLines(between: [center, lastVertexs[index]])
                }
                context?.drawPath(using: .stroke)
            }
            self.convertLocationIntoTarget(locationPoints: vertexs)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            context?.restoreGState()
            UIGraphicsEndImageContext()
            LiteChartDispatchQueue.asyncDrawDoneQueue.async {
                layer.contents = image?.cgImage
            }
        }
    }
    
    private func computeVertexsLocation(for centerPoint: CGPoint, radius: Double, radarLayerCount: Int) -> [[CGPoint]] {
        let angles = self.angleOfPoints
        let radiusInterval = radius / Double(radarLayerCount)
        let centerX = centerPoint.x
        let centerY = centerPoint.y
        var location: [[CGPoint]] = Array(repeating: [], count: radarLayerCount)
        for ind in 0 ..< angles.count {
            let curAngle = angles[ind]
            let sin = sinValue(of: curAngle)
            let cos = cosValue(of: curAngle)
            let allRadius = stride(from: radiusInterval, through: radius, by: radiusInterval)
            let offsetXs = allRadius.map{
                $0 * cos
            }
            let offsetYs = allRadius.map{
                $0 * sin
            }
            for index in 0 ..< radarLayerCount {
                let curPoint = CGPoint(x: Double(centerX) + offsetXs[index], y: Double(centerY) + offsetYs[index])
                location[index].append(curPoint)
            }
            
        }
        
        return location
    }
    
    private func convertLocationIntoTarget(locationPoints: [[CGPoint]]){
        if let points = locationPoints.last {
            self.targetPoints = points
        }
    }
    
    private func cosValue(of angle: Double) -> Double {
        return cos(Double.pi / 180 * angle)
    }
    
    private func sinValue(of angle: Double) -> Double {
        return sin(Double.pi / 180 * angle)
    }
    
}
