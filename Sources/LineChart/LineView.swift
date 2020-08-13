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
    
    private var labels: [DisplayLabel] = []
    private var legend: [UIView] = []
    
    init(configure: LineViewConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
        self.backgroundColor = .clear
        insertLabel()
        insertLegend()
    }
    
    required init?(coder: NSCoder) {
        self.configure = LineViewConfigure.emptyConfigure
        super.init(coder: coder)
        self.backgroundColor = .clear
        insertLabel()
        insertLegend()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateLabelsDynamicConstraints()
        updateLegendsDynamicConstraints()
        
        setNeedsDisplay()
    }
    
    private func insertLabel() {
        guard self.configure.isShowLabel else {
            return
        }
        guard self.configure.labelConfigure.count == self.configure.points.count else {
            fatalError("框架内部数据处理错误，不给予拯救")
        }
        for con in self.configure.labelConfigure {
            let label = DisplayLabel(configure: con)
            self.labels.append(label)
            self.addSubview(label)
        }
    }
    
    private func insertLegend() {
        for _ in self.configure.points {
            let legend = LegendFactory.shared.makeNewLegend(from: self.configure.legendConfigure)
            self.legend.append(legend)
            self.addSubview(legend)
        }
    }
    
    private func updateLabelsDynamicConstraints() {
        var labelWidth = self.bounds.width / CGFloat(self.labels.count * 4)
        var labelHeight = self.bounds.height / 20
        var space = labelHeight
        labelWidth = min(labelWidth, 40)
        labelHeight = min(labelHeight, 20)
        space = min(space, 8)
        
        for (index, label) in self.labels.enumerated() {
            let realPoint = self.convertScalePointToRealPointWtihLimit(for: self.configure.points[index])
            let center = CGPoint(x: realPoint.x, y: realPoint.y - space - labelHeight / 2)
            label.snp.updateConstraints{
                make in
                make.center.equalTo(center)
                make.width.equalTo(labelWidth)
                make.height.equalTo(labelHeight)
            }
        }
    }
    
    private func updateLegendsDynamicConstraints() {
        var legendWidth = self.bounds.width / 20
        var legendHeight = self.bounds.height / 20
        legendWidth = min(legendWidth, 8)
        legendHeight = min(legendHeight, 8)
        let legendLength = min(legendHeight, legendWidth)
        for (index, legend) in self.legend.enumerated() {
            let realPoint = self.convertScalePointToRealPointWtihLimit(for: self.configure.points[index])
            legend.snp.updateConstraints{
                make in
                make.center.equalTo(realPoint)
                make.width.equalTo(legendLength)
                make.height.equalTo(legendLength)
            }
        }
        
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setAllowsAntialiasing(true)
        context?.setShouldAntialias(true)
        context?.setStrokeColor(self.configure.lineColor.color.cgColor)
        context?.setLineJoin(.round)
        context?.setLineCap(.round)
        context?.setLineWidth(1)
        
        switch self.configure.lineStyle {
        case .dottedPolyline:
            context?.setLineDash(phase: 1, lengths: [6, 3])
            drawPolyline(for: self.configure.points, context: context)
        case .solidPolyline:
            context?.setLineDash(phase: 0, lengths: [])
            drawPolyline(for: self.configure.points, context: context)
        case .dottedCubicBezierCurve:
            context?.setLineDash(phase: 1, lengths: [6, 3])
            drawCubicBezierCurve(for: self.configure.points, context: context)
        case .solidCubicBezierCurve:
            context?.setLineDash(phase: 0, lengths: [])
            drawCubicBezierCurve(for: self.configure.points, context: context)
        }
    }
    
    private func convertScalePointToRealPointWtihLimit(for point: CGPoint) -> CGPoint {
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
        realPoint = CGPoint(x: self.bounds.width * realPoint.x + self.bounds.origin.x, y: self.bounds.origin.y + self.bounds.height * (1 - realPoint.y))
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
    
    private func drawPolyline(for points: [CGPoint], context: CGContext?) {
        guard points.count >= 2 else {
            return
        }
        let firstPoint = self.convertScalePointToRealPointWtihLimit(for: points[0])
        context?.move(to: firstPoint)
        var remain = points
        remain.removeFirst()
        for point in remain {
            let next = self.convertScalePointToRealPointWtihLimit(for: point)
            context?.addLine(to: next)
        }
        context?.drawPath(using: .stroke)
    }
    
    private func drawCubicBezierCurve(for points: [CGPoint], context: CGContext?) {
        guard points.count >= 2 else {
            return
        }
        let limitPoints = points.map{
            self.convertScalePointToRealPointWtihLimit(for: $0)
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
