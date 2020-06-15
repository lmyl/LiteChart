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
    
    let configure: LegendViewsConfigure
    var legendViews: [LegendView] = []
    
    init(configure: LegendViewsConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
        insertLegendViews()
    }
    
    required init?(coder: NSCoder) {
        self.configure = LegendViewsConfigure()
        super.init(coder: coder)
        insertLegendViews()
    }
    
    override func layoutSubviews() {
        superview?.layoutSubviews()
        self.updateLegendViewsConstraint()
    }
    
    private func insertLegendViews() {
        for configure in self.configure.models {
            let legendView = LegendView(configure: configure)
            self.addSubview(legendView)
            self.legendViews.append(legendView)
        }
    }
    
    private func updateLegendViewsConstraint() {
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
                    make.top.equalToSuperview()
                    make.width.equalToSuperview()
                    make.height.equalTo(itemHeight)
                    make.left.equalToSuperview()
                }
                continue
            }
            
            lengendView.snp.updateConstraints{
                make in
                make.top.equalTo(front.snp.bottom).offset(spaceHeight)
                make.width.equalToSuperview()
                make.height.equalTo(itemHeight)
                make.left.equalToSuperview()
            }
            frontView = lengendView
        }
    }
}
