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
    
    private let configure: LegendViewConfigure
    private var legendLeftView: UIView?
    private var legendRightView: DisplayLabel?
    
    init(configure: LegendViewConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
        insertLegendLeftView()
        insertLegendRightView()
        
        updateLegendLeftViewStaticConstraint()
        updateLegendRightViewStaticConstraint()
    }
    
    required init?(coder: NSCoder) {
        self.configure = LegendViewConfigure.emptyConfigure
        super.init(coder: coder)
        insertLegendLeftView()
        insertLegendRightView()
        
        updateLegendLeftViewStaticConstraint()
        updateLegendRightViewStaticConstraint()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateLegendLeftViewDynamicConstraint()
        updateLegendRightViewDynamicConstraint()
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
            legend = HexagonLegend(configure: self.configure.legendConfigure)
        }
        self.addSubview(legend)
        self.legendLeftView = legend
    }
    
    private func insertLegendRightView() {
        let legendLabel = DisplayLabel(configure: self.configure.contentConfigure)
        self.addSubview(legendLabel)
        self.legendRightView = legendLabel
    }
    
    private func updateLegendLeftViewStaticConstraint() {
        guard let leftView = self.legendLeftView else {
            return
        }
        leftView.snp.remakeConstraints{
            make in
            make.width.equalTo(0)
            make.height.equalTo(0)
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    private func updateLegendLeftViewDynamicConstraint() {
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
        }
    }
    
    private func updateLegendRightViewStaticConstraint() {
        guard let rightView = self.legendRightView else {
            return
        }
        guard let leftView = self.legendLeftView else {
            return
        }
        rightView.snp.updateConstraints{
            make in
            make.left.equalTo(leftView.snp.right)
            make.right.equalToSuperview()
            make.height.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    private func updateLegendRightViewDynamicConstraint() {
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
        }
    }
}
