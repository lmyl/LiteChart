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
    
    var radarDataViews: [RadarDataView] = []
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updataRadarDataViewConstraints()
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
            let angle = 360 / Double(self.configure.pointCount) * Double(index) - 90
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
    
    func insertRadarDataViews(for configures: [RadarDataViewConfigure]) {
        guard configures.count > 0 else {
            return
        }
        for configure in configures {
            let radarDataView = RadarDataView(configure: configure)
            self.addSubview(radarDataView)
            self.radarDataViews.append(radarDataView)
        }
    }
    
    private func updataRadarDataViewConstraints() {
        var width: CGFloat
        var height: CGFloat
        if self.configure.coupleTitlesConfigure.count == 0 {
             width = self.bounds.width
             height = self.bounds.height
        } else {
             width = self.bounds.width - 2 * coupleTitleWidth
             height = self.bounds.height - 2 * coupleTitleHeight
        }
        
        for radarDataView in radarDataViews {
            radarDataView.snp.updateConstraints{
                make in
                make.center.equalToSuperview()
                make.width.equalTo(width)
                make.height.equalTo(height)
            }
        }
    }
    
    private func updateCoupleTitleConstraints(for endPoints: [CGPoint]) {
        guard self.coupleTitles.count >= 3, self.angleOfPoints.count == endPoints.count, endPoints.count == self.coupleTitles.count else {
            return
        }
        if endPoints.count != self.coupleTitles.count {
            fatalError("内部数据处理错误，不给予拯救")
        }
        let coupleTitles = self.coupleTitles
        let angleOfPoints = self.angleOfPoints
        for (index, coupleTitleView) in coupleTitles.enumerated() {
            var center = CGPoint.zero
            if angleOfPoints[index] == -90 {
                let centerY = endPoints[index].y - coupleTitleHeight / 2
                let centerX = endPoints[index].x
                center = CGPoint(x: centerX, y: centerY)
            } else if angleOfPoints[index] == 90 {
                let centerY = endPoints[index].y + coupleTitleHeight / 2
                let centerX = endPoints[index].x
                center = CGPoint(x: centerX, y: centerY)
            } else if angleOfPoints[index] > 90 {
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
        
        let radius: CGFloat
        if self.configure.coupleTitlesConfigure.count != 0 {
            let tempWidth = rect.width - 2 * coupleTitleWidth
            let tempHeight = rect.height - 2 * coupleTitleHeight
            radius = min(tempWidth, tempHeight) / 2
        } else {
            radius = min(rect.width, rect.height) / 2
        }
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let vertexs = computeVertexsLocation(for: center, radius: Double(radius), pointCount: self.configure.pointCount, radarCount: self.configure.radarCount)
        
        for index in (0 ..< self.configure.radarCount).reversed() {
            context?.addLines(between: vertexs[index])
            context?.closePath()
            if index % 2 == 0{
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
        convertLocationIntoTarget(locationPoints: vertexs)
    }
    
    private func computeVertexsLocation(for centerPoint: CGPoint, radius: Double, pointCount: Int, radarCount: Int) -> [[CGPoint]] {
        let angles = self.angleOfPoints
        let radiusInterval = radius / Double(radarCount)
        let centerX = centerPoint.x
        let centerY = centerPoint.y
        var location: [[CGPoint]] = Array(repeating: [], count: radarCount)
        for ind in 0 ..< angles.count {
            let curAngle = angleOfPoints[ind]
            let sin = sinValue(of: curAngle)
            let cos = cosValue(of: curAngle)
            let allRadius = stride(from: radiusInterval, through: radius, by: radiusInterval)
            let offsetXs = allRadius.map{
                $0 * cos
            }
            let offsetYs = allRadius.map{
                $0 * sin
            }
            for index in 0 ..< radarCount {
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
