//
//  LegendView.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/6.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit
import SnapKit

class LegendView: UIView {
    
    let configure: LegendViewConfigure
    var legendLeftView: UIView?
    var legendRightView: DisplayLabel?
    
    init(configure: LegendViewConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
        insertLegendLeftView()
        insertLegendRightView()
    }
    
    required init?(coder: NSCoder) {
        self.configure = LegendViewConfigure()
        super.init(coder: coder)
        insertLegendLeftView()
        insertLegendRightView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateLegendLeftViewConstraint()
        updateLegendRightViewConstraint()
    }
    
    private func insertLegendLeftView() {
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
            legend = hexagonLegend(configure: self.configure.legendConfigure)
        }
        self.addSubview(legend)
        self.legendLeftView = legend
    }
    
    private func insertLegendRightView() {
        let legendLabel = DisplayLabel(configure: self.configure.contentConfigure)
        self.addSubview(legendLabel)
        self.legendRightView = legendLabel
    }
    
    private func updateLegendLeftViewConstraint() {
        let width = self.bounds.width
        let height = self.bounds.height
        let squareWidth = min(width, height)
        guard let leftView = self.legendLeftView else {
            return
        }
        leftView.snp.updateConstraints{
            make in
            make.width.equalTo(squareWidth)
            make.height.equalTo(squareWidth)
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    private func updateLegendRightViewConstraint() {
        guard let rightView = self.legendRightView else {
            return
        }
        guard let leftView = self.legendLeftView else {
            return
        }
        let remain = self.bounds.width - min(self.bounds.width, self.bounds.height)
        let offset = min(remain /  10, 4)
        rightView.snp.updateConstraints{
            make in
            make.left.equalTo(leftView.snp.right).offset(offset)
            make.right.equalToSuperview()
            make.height.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}
