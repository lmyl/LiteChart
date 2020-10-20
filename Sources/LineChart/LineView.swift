//
//  LineView.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/16.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit
import SnapKit

class LineView: UIView {
    private let configure: LineViewConfigure
    
    private var legend: [UIView] = []
    
    private var insideAnimationStatus: LiteChartAnimationStatus = .ready
    private let animationGrowKey = "Grow"
    
    init(configure: LineViewConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
    }
    
    required init?(coder: NSCoder) {
        self.configure = LineViewConfigure.emptyConfigure
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
            let context = UIGraphicsGetCurrentContext()
            let rect = layer.bounds
            context?.saveGState()
            context?.setAllowsAntialiasing(true)
            context?.setShouldAntialias(true)
            context?.setStrokeColor(self.configure.lineColor.color.cgColor)
            context?.setLineJoin(.round)
            context?.setLineCap(.round)
            context?.setLineWidth(1)
            
            switch self.configure.lineStyle {
            case .dottedPolyline:
                context?.setLineDash(phase: 1, lengths: [6, 3])
                self.drawPolyline(for: self.configure.points, context: context, in: rect)
            case .solidPolyline:
                context?.setLineDash(phase: 0, lengths: [])
                self.drawPolyline(for: self.configure.points, context: context, in: rect)
            case .dottedCubicBezierCurve:
                context?.setLineDash(phase: 1, lengths: [6, 3])
                self.drawCubicBezierCurve(for: self.configure.points, context: context, in: rect)
            case .solidCubicBezierCurve:
                context?.setLineDash(phase: 0, lengths: [])
                self.drawCubicBezierCurve(for: self.configure.points, context: context, in: rect)
            }
            
            let image = UIGraphicsGetImageFromCurrentImageContext()
            context?.restoreGState()
            UIGraphicsEndImageContext()
            LiteChartDispatchQueue.asyncDrawDoneQueue.async {
                layer.contents = image?.cgImage
            }
        }
    }
    
    private func convertScalePointToRealPointWtihLimit(for point: CGPoint, rect: CGRect) -> CGPoint {
        var realPoint = point
        if realPoint.x < 0 {
            realPoint.x = 0
        } else if realPoint.x > 1 {
            realPoint.x = 1
        }
        
        if realPoint.y < 0 {
            realPoint.y = 0
        } else if realPoint.y > 1 {
            realPoint.y = 1
        }
        realPoint = CGPoint(x: rect.width * realPoint.x + rect.origin.x, y: rect.origin.y + rect.height * (1 - realPoint.y))
        return realPoint
    }
    
    private func computeControlPointsFrom(firstPoint: CGPoint, secondPoint: CGPoint, thirdPoint: CGPoint, fourthPoint: CGPoint) -> (firstControl: CGPoint, secondControl: CGPoint) {
        let smoothValue: CGFloat = 0.6
        let firstControlX = (firstPoint.x + secondPoint.x) / 2
        let firstControlY = (firstPoint.y + secondPoint.y) / 2
        let secondControlX = (secondPoint.x + thirdPoint.x) / 2
        let secondControlY = (secondPoint.y + thirdPoint.y) / 2
        let thirdControlX = (thirdPoint.x + fourthPoint.x) / 2
        let thirdControlY = (thirdPoint.y + fourthPoint.y) / 2
        var distanceFirstToSecond = (firstPoint.x - secondPoint.x) * (firstPoint.x - secondPoint.x) + (firstPoint.y - secondPoint.y) * (firstPoint.y - secondPoint.y)
        distanceFirstToSecond = pow(distanceFirstToSecond, 0.5)
        var distanceSecondToThird = (secondPoint.x - thirdPoint.x) * (secondPoint.x - thirdPoint.x) + (secondPoint.y - thirdPoint.y) * (secondPoint.y - thirdPoint.y)
        distanceSecondToThird = pow(distanceSecondToThird, 0.5)
        var distanceThirdToFourth = (thirdPoint.x - fourthPoint.x) * (thirdPoint.x - fourthPoint.x) + (thirdPoint.y - fourthPoint.y) * (thirdPoint.y - fourthPoint.y)
        distanceThirdToFourth = pow(distanceThirdToFourth, 0.5)
        let slopeFirst = distanceFirstToSecond / (distanceFirstToSecond + distanceSecondToThird)
        let slopeSecond = distanceSecondToThird / (distanceSecondToThird + distanceThirdToFourth)
        let middleFirstX = firstControlX + (secondControlX - firstControlX) * slopeFirst
        let middleFirstY = firstControlY + (secondControlY - firstControlY) * slopeFirst
        let middleSecondX = secondControlX + (thirdControlX - secondControlX) * slopeSecond
        let middleSecondY = secondControlY + (thirdControlY - secondControlY) * slopeSecond
        let finalControlFirstX = (secondControlX - middleFirstX) * smoothValue + secondPoint.x
        let finalControlFirstY = (secondControlY - middleFirstY) * smoothValue + secondPoint.y
        let finalControlSecondX = (secondControlX - middleSecondX) * smoothValue + thirdPoint.x
        let finalControlSecondY = (secondControlY - middleSecondY) * smoothValue + thirdPoint.y
        let finalControlFirst = CGPoint(x: finalControlFirstX, y: finalControlFirstY)
        let finalControlSecond = CGPoint(x: finalControlSecondX, y: finalControlSecondY)
        return (finalControlFirst, finalControlSecond)
    }
    
    private func computeControlPointsFrom(points: [CGPoint]) -> [(firstControl: CGPoint, secondControl: CGPoint)] {
        guard points.count >= 2 else {
            return []
        }
        let firstCount = 0
        let finalCount = points.count - 1
        let firstGapX = points[firstCount].x - points[firstCount + 1].x
        let firstGapY = points[firstCount].y - points[firstCount + 1].y
        var leftPaddingY = points[firstCount].y
        if firstGapX != 0 {
            let slopeFirst = firstGapY / firstGapX
            let remainFirst = points[firstCount + 1].y - slopeFirst * points[firstCount + 1].x
            leftPaddingY = remainFirst
        }
        let finalGapX = points[finalCount].x - points[finalCount - 1].x
        let finalGapY = points[finalCount].y - points[finalCount - 1].y
        var rightPaddingY = points[finalCount].y
        if finalGapX != 0 {
            let slopeFinal = finalGapY / finalGapX
            let remainFinal = points[finalCount - 1].y - slopeFinal * points[finalCount - 1].x
            rightPaddingY = slopeFinal + remainFinal
        }
        let leftPaddingPoint = CGPoint(x: 0, y: leftPaddingY)
        let rightPaddingPoint = CGPoint(x: 1, y: rightPaddingY)
        
        let allPoints = [leftPaddingPoint] + points + [rightPaddingPoint]
        var result: [(CGPoint, CGPoint)] = []
        for index in 0 ... allPoints.count - 4 {
            let temp = computeControlPointsFrom(firstPoint: allPoints[index], secondPoint: allPoints[index + 1], thirdPoint: allPoints[index + 2], fourthPoint: allPoints[index + 3])
            result.append(temp)
        }
        return result
    }
    
    private func drawPolyline(for points: [CGPoint], context: CGContext?, in rect: CGRect) {
        guard points.count >= 2 else {
            return
        }
        let firstPoint = self.convertScalePointToRealPointWtihLimit(for: points[0], rect: rect)
        context?.move(to: firstPoint)
        var remain = points
        remain.removeFirst()
        for point in remain {
            let next = self.convertScalePointToRealPointWtihLimit(for: point, rect: rect)
            context?.addLine(to: next)
        }
        context?.drawPath(using: .stroke)
    }
    
    private func drawCubicBezierCurve(for points: [CGPoint], context: CGContext?, in rect: CGRect) {
        guard points.count >= 2 else {
            return
        }
        let limitPoints = points.map{
            self.convertScalePointToRealPointWtihLimit(for: $0, rect: rect)
        }
        let allControlPoints = computeControlPointsFrom(points: limitPoints)
        guard !allControlPoints.isEmpty else {
            return
        }
        let firstPoint = limitPoints[0]
        context?.move(to: firstPoint)
        var remain = limitPoints
        remain.removeFirst()
        guard remain.count == allControlPoints.count else {
            fatalError("框架内部数据处理错误，不给予拯救!")
        }
        for index in 0 ..< remain.count {
            let nextPoint = remain[index]
            let nextControlPointFirst = allControlPoints[index].firstControl
            let nextControlPointSecond = allControlPoints[index].secondControl
            context?.addCurve(to: nextPoint, control1: nextControlPointFirst, control2: nextControlPointSecond)
        }
        context?.drawPath(using: .stroke)
    }
    
}

extension LineView: LiteChartAnimatable {
    func startAnimation(animation: LiteChartAnimationInterface) {
        guard self.insideAnimationStatus == .ready || self.insideAnimationStatus == .cancel || self.insideAnimationStatus == .finish else {
            return
        }
        guard case .base(let duration) = animation.animationType else {
            return
        }
        guard self.configure.points.count >= 2, let last = self.configure.points.last else {
            return
        }
        let maskLayer = CAShapeLayer()
        maskLayer.fillColor = UIColor.black.cgColor
        maskLayer.opacity = 1
        maskLayer.frame = self.layer.bounds
        let firstPoint = self.convertScalePointToRealPointWtihLimit(for: self.configure.points[0], rect: self.layer.bounds)
        let lastPoint = self.convertScalePointToRealPointWtihLimit(for: last, rect: self.layer.bounds)
        let maskRect = CGRect(x: firstPoint.x, y: self.layer.bounds.origin.y, width: lastPoint.x - firstPoint.x, height: self.layer.bounds.height)
        let initRect = CGRect(x: firstPoint.x, y: self.layer.bounds.origin.y, width: 0, height: self.layer.bounds.height)
        maskLayer.path = UIBezierPath(rect: maskRect).cgPath
        
        let current = CACurrentMediaTime()
        let pathKey = "path"
        let maskExpandAnimation = animation.animationType.quickAnimation(keyPath: pathKey)
        maskExpandAnimation.fromValue = UIBezierPath(rect: initRect).cgPath
        maskExpandAnimation.toValue = UIBezierPath(rect: maskRect).cgPath
        
        maskExpandAnimation.beginTime = current + animation.delay
        maskExpandAnimation.fillMode = animation.fillModel
        maskExpandAnimation.timingFunction = animation.timingFunction
        maskExpandAnimation.duration = duration
        maskExpandAnimation.delegate = self
        
        self.layer.syncTimeSystemToFather()
        self.layer.mask = maskLayer
        maskLayer.add(maskExpandAnimation, forKey: animationGrowKey)
        
        self.insideAnimationStatus = .running
    }
    
    func stopAnimation() {
        guard self.insideAnimationStatus == .running || self.insideAnimationStatus == .pause else {
            return
        }
        self.layer.mask?.removeAnimation(forKey: animationGrowKey)
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

extension LineView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.layer.mask = nil
        if self.insideAnimationStatus != .cancel {
            self.insideAnimationStatus = .finish
        }
    }
}
