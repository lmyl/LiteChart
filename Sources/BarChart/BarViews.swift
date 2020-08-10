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
    private let configure: BarViewsConfigure
    
    private var barViews: [BarView] = []
    
    init(configure: BarViewsConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
        insertBars()
        
        updateBarViewsStaticConstraints()
    }
    
    required init?(coder: NSCoder) {
        self.configure = BarViewsConfigure.emptyConfigure
        super.init(coder: coder)
        insertBars()
        
        updateBarViewsStaticConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateBarViewsDynamicConstraints()
    }
    
    private func insertBars() {
        for barviewConfigure in self.configure.models {
            let barview = BarView(configure: barviewConfigure)
            self.addSubview(barview)
            self.barViews.append(barview)
        }
    }
    
    private func updateBarViewsStaticConstraints() {
        switch self.configure.direction {
        case .bottomToTop:
            var frontBar: BarView?
            for bar in self.barViews {
                guard let front = frontBar else {
                    bar.snp.updateConstraints{
                        make in
                        make.left.equalToSuperview()
                        make.width.equalTo(0)
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
                    make.width.equalTo(0)
                }
                frontBar = bar
            }
        case .leftToRight:
            var frontBar: BarView?
            for bar in self.barViews {
                guard let front = frontBar else {
                    bar.snp.updateConstraints{
                        make in
                        make.left.equalToSuperview()
                        make.right.equalToSuperview()
                        make.top.equalToSuperview()
                        make.height.equalTo(0)
                    }
                    frontBar = bar
                    continue
                }
                bar.snp.updateConstraints{
                    make in
                    make.left.equalToSuperview()
                    make.right.equalToSuperview()
                    make.top.equalTo(front.snp.bottom)
                    make.height.equalTo(0)
                }
                frontBar = bar
            }
        }
    }
    
    private func updateBarViewsDynamicConstraints() {
        switch self.configure.direction {
        case .bottomToTop:
            let itemWidth = self.bounds.width / CGFloat(self.barViews.count + 1)
            let leftSpace = itemWidth / 2
            var frontBar: BarView?
            for bar in self.barViews {
                guard let _ = frontBar else {
                    bar.snp.updateConstraints{
                        make in
                        make.left.equalToSuperview().offset(leftSpace)
                        make.width.equalTo(itemWidth)
                    }
                    frontBar = bar
                    continue
                }
                bar.snp.updateConstraints{
                    make in
                    make.width.equalTo(itemWidth)
                }
                frontBar = bar
            }
        case .leftToRight:
            let itemHeight = self.bounds.height / CGFloat(self.barViews.count + 1)
            let topSpace = itemHeight / 2
            var frontBar: BarView?
            for bar in self.barViews {
                guard let _ = frontBar else {
                    bar.snp.updateConstraints{
                        make in
                        make.top.equalToSuperview().offset(topSpace)
                        make.height.equalTo(itemHeight)
                    }
                    frontBar = bar
                    continue
                }
                bar.snp.updateConstraints{
                    make in
                    make.height.equalTo(itemHeight)
                }
                frontBar = bar
            }
        }
        
    }
}
