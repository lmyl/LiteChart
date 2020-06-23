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
    let configure: RadarBackgroundViewConfigure
    
    var coupleTitles: [DisplayLabel] = []
    
    private var targetPoints: [CGPoint] = [] {
        didSet {
            if targetPoints.count != oldValue.count {
                self.updateCoupleTitleConstraints(for: targetPoints)
            }
        }
    }
    
    init(configure: RadarBackgroundViewConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
        self.backgroundColor = .clear
        self.insertCoupleTitle()
    }
    
    required init?(coder: NSCoder) {
        self.configure = RadarBackgroundViewConfigure()
        super.init(coder: coder)
        self.backgroundColor = .clear
        self.insertCoupleTitle()
    }
    
    private var coupleTitleWidth: CGFloat {
        let width = self.bounds.width / 10
        return min(width, 40)
    }
    
    private var coupleTitleHeight: CGFloat {
        let height = self.bounds.height / 20
        return min(height, 20)
    }
    
    private var angleOfPoints: [Double] {
        var angles = [Double]()
        for index in 0 ..< self.configure.pointCount {
            let angle = 360 / Double(self.configure.pointCount) * Double(index)
            angles.append(angle)
        }
        return angles
    }
    
    private func insertCoupleTitle() {
        for label in self.configure.coupleTitlesConfigure {
            let title = DisplayLabel(configure: label)
            self.addSubview(title)
            self.coupleTitles.append(title)
        }
    }
    
    private func updateCoupleTitleConstraints(for endPoints: [CGPoint]) {
        guard self.coupleTitles.count >= 3, self.angleOfPoints.count == endPoints.count, endPoints.count == self.coupleTitles.count else {
            return
        }
        
        let coupleTitles = self.coupleTitles
        let angleOfPoints = self.angleOfPoints
        for (index, coupleTitleView) in coupleTitles.enumerated() {
            var center = CGPoint.zero
            if angleOfPoints[index] == 0 {
                let centerY = endPoints[index].y - coupleTitleHeight / 2
                let centerX = endPoints[index].x
                center = CGPoint(x: centerX, y: centerY)
            } else if angleOfPoints[index] == 180 {
                let centerY = endPoints[index].y + coupleTitleHeight / 2
                let centerX = endPoints[index].x
                center = CGPoint(x: centerX, y: centerY)
            } else if angleOfPoints[index] < 180 {
                let centerY = endPoints[index].y
                let centerX = endPoints[index].x - coupleTitleWidth / 2
                center = CGPoint(x: centerX, y: centerY)
            } else {
                let centerY = endPoints[index].y
                let centerX = endPoints[index].x + coupleTitleWidth / 2
                center = CGPoint(x: centerX, y: centerY)
            }

            coupleTitleView.snp.updateConstraints{
                make in
                make.height.equalTo(coupleTitleHeight)
                make.width.equalTo(coupleTitleWidth)
                make.center.equalTo(center)
            }
            coupleTitleView.layoutIfNeeded()
        }
    }
    
    override func draw(_ rect: CGRect) { // 需要精简
        let context = UIGraphicsGetCurrentContext()
        context?.setAllowsAntialiasing(true)
        context?.setShouldAntialias(true)
        context?.setStrokeColor(self.configure.radarLineColor.color.cgColor)
        context?.setLineCap(.round)
        context?.setLineJoin(.round)
        context?.setLineWidth(1)
        
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        
        let radius: CGFloat
        if self.configure.coupleTitlesConfigure.count != 0 {
            let tempWidth = rect.width - 2 * coupleTitleWidth
            let tempHeight = rect.height - 2 * coupleTitleHeight
            radius = min(tempWidth, tempHeight) / 2
        } else {
            radius = min(rect.width, rect.height) / 2
        }
        let angleInterval = 360 / self.configure.pointCount
        
        var vertexs: [[CGPoint]] = Array(repeating: [], count: self.configure.radarCount)
        let radiusInterval = radius / CGFloat(self.configure.radarCount)
        for index in 0 ..< self.configure.radarCount {
            let newRadius = radiusInterval * CGFloat(index + 1)
            let topX = center.x
            let topY = center.y - newRadius
            let topPoint = CGPoint(x: topX, y: topY)
            vertexs[index].append(topPoint)
            for ind in 0 ..< self.configure.pointCount {
                let offsetX = newRadius * sinValue(of: Double(angleInterval) * Double(ind + 1))
                let offsetY = newRadius * cosValue(of: Double(angleInterval) * Double(ind + 1))
                let curPoint = CGPoint(x: topX - offsetX, y: topY - offsetY + newRadius)
                vertexs[index].append(curPoint)
            }
        }
        for index in (0 ..< self.configure.radarCount).reversed() { // 绘制层
            context?.addLines(between: vertexs[index])
            if index % 2 == 0{
                context?.setFillColor(self.configure.radarLightColor.color.cgColor)
            } else {
                context?.setFillColor(self.configure.radarUnlightColor.color.cgColor)
            }
            context?.drawPath(using: .fillStroke)
        }
        guard let lastVertexs = vertexs.last else { // 绘制中心点到顶点的连线
            fatalError()
        }
        for index in 0 ..< lastVertexs.count {
            context?.addLines(between: [center, lastVertexs[index]])
        }
        context?.drawPath(using: .stroke)
        
        var endPoints = lastVertexs
        endPoints.removeLast()
        self.targetPoints = endPoints
    }
    
    private func cosValue(of angle: Double) -> CGFloat {
        return CGFloat(cos(Double.pi / 180 * angle))
    }
    
    private func sinValue(of angle: Double) -> CGFloat {
        return CGFloat(sin(Double.pi / 180 * angle))
    }
    
}
