//
//  PointsView.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/20.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit
import SnapKit

class PointsView: UIView {
    private let configure: PointsViewConfigure
    private var points: [UIView] = []
    
    init(configure: PointsViewConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
        insertPoints()
    }
    
    required init?(coder: NSCoder) {
        self.configure = PointsViewConfigure.emptyConfigure
        super.init(coder: coder)
        insertPoints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updatePointsDynmaicConstrints()
    }
    
    private func insertPoints() {
        for uiView in self.points {
            uiView.removeFromSuperview()
        }
        self.points = []
        for point in self.configure.points {
            let uiview = LegendFactory.shared.makeNewLegend(from: point.legendConfigure)
            var opacity = point.opacity
            if opacity > 1 {
                opacity = 1
            } else if opacity < 0 {
                opacity = 0
            }
            
            uiview.alpha = opacity
            self.addSubview(uiview)
            self.points.append(uiview)
        }
    }
    
    private func updatePointsDynmaicConstrints() {
        guard self.points.count == self.configure.points.count else {
            fatalError("框架内部数据处理错误，不给予拯救")
        }
        for (index, point) in self.points.enumerated() {
            var pointLocation = self.configure.points[index].location
            if pointLocation.x < 0 {
                pointLocation.x = 0
            } else if pointLocation.x > 1 {
                pointLocation.x = 1
            }
            
            if pointLocation.y < 0 {
                pointLocation.y = 1
            } else if pointLocation.y > 1 {
                pointLocation.y = 0
            } else {
                pointLocation.y = 1 - pointLocation.y
            }
            
            let center = CGPoint(x: self.bounds.width * pointLocation.x + self.bounds.origin.x, y: self.bounds.height * pointLocation.y + self.bounds.origin.y)
            
            let initWidth = self.bounds.width / 40
            let initHeight = self.bounds.height / 40
            let initLength = min(initWidth, initHeight)
            var scaleSize = self.configure.points[index].size
            if scaleSize < 1 {
                scaleSize = 1
            }
            let finalLength = initLength * scaleSize
            
            point.snp.updateConstraints{
                make in
                make.width.equalTo(finalLength)
                make.height.equalTo(finalLength)
                make.center.equalTo(center)
            }
        }
    }
}
