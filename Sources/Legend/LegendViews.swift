//
//  LegendViews.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/6.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit
import SnapKit

class LegendViews: UIView {
    
    private let configure: LegendViewsConfigure
    private var legendViews: [LegendView] = []
    
    init(configure: LegendViewsConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
        insertLegendViews()
        
        updateLegendViewsStaticConstraint()
    }
    
    required init?(coder: NSCoder) {
        self.configure = LegendViewsConfigure.emptyConfigure
        super.init(coder: coder)
        insertLegendViews()
        
        updateLegendViewsStaticConstraint()
    }
    
    override func layoutSubviews() {
        superview?.layoutSubviews()
        self.updateLegendViewsDynamicConstraint()
    }
    
    private func insertLegendViews() {
        for configure in self.configure.models {
            let legendView = LegendView(configure: configure)
            self.addSubview(legendView)
            self.legendViews.append(legendView)
        }
    }
    
    private func updateLegendViewsStaticConstraint() {
        var frontView: LegendView?
        for lengendView in self.legendViews {
            guard let front = frontView else {
                frontView = lengendView
                lengendView.snp.remakeConstraints{
                    make in
                    make.top.equalToSuperview()
                    make.width.equalToSuperview()
                    make.height.equalTo(0)
                    make.left.equalToSuperview()
                }
                continue
            }
            
            lengendView.snp.remakeConstraints{
                make in
                make.top.equalTo(front.snp.bottom)
                make.width.equalToSuperview()
                make.height.equalTo(0)
                make.left.equalToSuperview()
            }
            frontView = lengendView
        }
    }
    
    private func updateLegendViewsDynamicConstraint() {
        guard !self.legendViews.isEmpty else {
            return
        }
        
        var itemHeight = self.bounds.height / CGFloat(self.legendViews.count)
        itemHeight = min(itemHeight, self.bounds.width / 2, 20)
        let spaceHeight = itemHeight / 10
        itemHeight = itemHeight - spaceHeight
        
        var frontView: LegendView?
        for lengendView in self.legendViews {
            guard let front = frontView else {
                frontView = lengendView
                lengendView.snp.updateConstraints{
                    make in
                    make.height.equalTo(itemHeight)
                }
                continue
            }
            
            lengendView.snp.updateConstraints{
                make in
                make.top.equalTo(front.snp.bottom).offset(spaceHeight)
                make.height.equalTo(itemHeight)
            }
            frontView = lengendView
        }
    }
}
