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
    let configure: LineViewConfigure
    
    var labels: [DisplayLabel] = []
    var legend: [UIView] = []
    
    init(configure: LineViewConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
        self.backgroundColor = .clear
        insertLabel()
        insertLegend()
    }
    
    required init?(coder: NSCoder) {
        self.configure = LineViewConfigure()
        super.init(coder: coder)
        self.backgroundColor = .clear
        insertLabel()
        insertLegend()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateLabelsConstraints()
        updateLegendsConstraints()
    }
    
    private func insertLabel() {
        guard let configure = self.configure.labelConfigure else {
            return
        }
        guard configure.count == self.configure.points.count else {
            fatalError("框架内部数据处理错误，不给予拯救")
        }
        for con in  configure {
            let label = DisplayLabel(configure: con)
            self.labels.append(label)
            self.addSubview(label)
        }
    }
    
    private func insertLegend() {
        for _ in self.configure.points {
            let legend: UIView
            switch self.configure.legendType {
            case .square:
                legend = SquareLegend(configure: self.configure.legendConfigure)
            case .triangle:
                legend = TriangleLegend(configure: self.configure.legendConfigure)
            case .circle:
                legend = CircleLegend(configure: self.configure.legendConfigure)
            case .pentagram:
                legend = PentagramLegend(configure: self.configure.legendConfigure)
            case .hexagon:
                legend = HexagonLegend(configure: self.configure.legendConfigure)
            }
            self.legend.append(legend)
            self.addSubview(legend)
        }
    }
    
    private func updateLabelsConstraints() {
        var labelWidth = self.bounds.width / CGFloat(self.labels.count * 4)
        var labelHeight = self.bounds.height / 20
        var space = labelHeight
        labelWidth = min(labelWidth, 40)
        labelHeight = min(labelHeight, 20)
        space = min(space, 8)
        
        for (index, label) in self.labels.enumerated() {
            let realPoint = self.convertScalePointToRealPoint(for: self.configure.points[index])
            let center = CGPoint(x: realPoint.x, y: realPoint.y - space - labelHeight / 2)
            label.snp.updateConstraints{
                make in
                make.center.equalTo(center)
                make.width.equalTo(labelWidth)
                make.height.equalTo(labelHeight)
            }
        }
    }
    
    private func updateLegendsConstraints() {
        var legendWidth = self.bounds.width / 20
        var legendHeight = self.bounds.height / 20
        legendWidth = min(legendWidth, 8)
        legendHeight = min(legendHeight, 8)
        let legendLength = min(legendHeight, legendWidth)
        for (index, legend) in self.legend.enumerated() {
            let realPoint = self.convertScalePointToRealPoint(for: self.configure.points[index])
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
        case .dotted:
            context?.setLineDash(phase: 1, lengths: [6, 3])
        case .solid:
            context?.setLineDash(phase: 0, lengths: [])
        }
        
        var frontPoint: CGPoint?
        for point in self.configure.points {
            let realPoint = self.convertScalePointToRealPoint(for: point)
            guard let _ = frontPoint else {
                context?.move(to: realPoint)
                frontPoint = realPoint
                continue
            }
            context?.addLine(to: realPoint)
            context?.move(to: realPoint)
            frontPoint = realPoint
        }
        
        context?.drawPath(using: .stroke)
        
    }
    
    private func convertScalePointToRealPoint(for point: CGPoint) -> CGPoint {
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
}
