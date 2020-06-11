//
//  BarViews.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/11.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit
import SnapKit

class BarViews: UIView {
    let configure: BarViewsConfigure
    
    private var barViews: [BarView] = []
    
    init(configure: BarViewsConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
        insertBars()
    }
    
    required init?(coder: NSCoder) {
        self.configure = BarViewsConfigure()
        super.init(coder: coder)
        insertBars()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateBarViews()
    }
    
    private func insertBars() {
        for barviewConfigure in self.configure.models {
            let barview = BarView(configure: barviewConfigure)
            self.addSubview(barview)
            self.barViews.append(barview)
        }
    }
    
    private func updateBarViews() {
        switch self.configure.direction {
        case .bottomToTop:
            let itemWidth = self.bounds.width / CGFloat(self.barViews.count + 1)
            let leftSpace = itemWidth / 2
            var frontBar: BarView?
            for bar in self.barViews {
                guard let front = frontBar else {
                    bar.snp.updateConstraints{
                        make in
                        make.left.equalToSuperview().offset(leftSpace)
                        make.width.equalTo(itemWidth)
                        make.top.equalToSuperview()
                        make.bottom.equalToSuperview()
                    }
                    frontBar = bar
                    continue
                }
                bar.snp.updateConstraints{
                    make in
                    make.left.equalTo(front.snp.right)
                    make.bottom.equalToSuperview()
                    make.top.equalToSuperview()
                    make.width.equalTo(itemWidth)
                }
                frontBar = bar
            }
        case .leftToRight:
            let itemHeight = self.bounds.height / CGFloat(self.barViews.count + 1)
            let topSpace = itemHeight / 2
            var frontBar: BarView?
            for bar in self.barViews {
                guard let front = frontBar else {
                    bar.snp.updateConstraints{
                        make in
                        make.left.equalToSuperview()
                        make.right.equalToSuperview()
                        make.top.equalToSuperview().offset(topSpace)
                        make.height.equalTo(itemHeight)
                    }
                    frontBar = bar
                    continue
                }
                bar.snp.updateConstraints{
                    make in
                    make.left.equalToSuperview()
                    make.right.equalToSuperview()
                    make.top.equalTo(front.snp.bottom)
                    make.height.equalTo(itemHeight)
                }
                frontBar = bar
            }
        }
        
    }
}
