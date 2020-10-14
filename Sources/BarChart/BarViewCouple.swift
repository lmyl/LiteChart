//
//  BarViews.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/11.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit
import SnapKit

class BarViewCouple: UIView {
    private let configure: BarViewCoupleConfigure
    
    private var barViews: [BarView] = []
    
    init(configure: BarViewCoupleConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
        insertBars()
        
        updateBarViewsStaticConstraints()
    }
    
    required init?(coder: NSCoder) {
        self.configure = BarViewCoupleConfigure.emptyConfigure
        super.init(coder: coder)
        insertBars()
        
        updateBarViewsStaticConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateBarViewsDynamicConstraints()
    }
    
    private func insertBars() {
        for bar in self.barViews {
            bar.removeFromSuperview()
        }
        self.barViews = []
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
                bar.snp.remakeConstraints{
                    make in
                    if let front = frontBar {
                        make.leading.equalTo(front.snp.trailing)
                        make.width.equalTo(front.snp.width)
                    } else {
                        make.leading.equalToSuperview().priority(750)
                        make.width.equalTo(0)
                    }
                    make.top.equalToSuperview()
                    make.bottom.equalToSuperview()
                }
                frontBar = bar
            }
        case .leftToRight:
            var frontBar: BarView?
            for bar in self.barViews {
                bar.snp.remakeConstraints{
                    make in
                    if let front = frontBar {
                        make.top.equalTo(front.snp.bottom)
                        make.height.equalTo(front.snp.height)
                    } else {
                        make.top.equalToSuperview().priority(750)
                        make.height.equalTo(0)
                    }
                    make.leading.equalToSuperview()
                    make.trailing.equalToSuperview()
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
            guard let frontBar = self.barViews.first else {
                return
            }
            frontBar.snp.updateConstraints{
                make in
                make.leading.equalToSuperview().offset(leftSpace).priority(750)
                make.width.equalTo(itemWidth)
            }
        case .leftToRight:
            let itemHeight = self.bounds.height / CGFloat(self.barViews.count + 1)
            let topSpace = itemHeight / 2
            guard let frontBar = self.barViews.first else {
                return
            }
            frontBar.snp.updateConstraints{
                make in
                make.top.equalToSuperview().offset(topSpace).priority(750)
                make.height.equalTo(itemHeight)
            }
        }
        
    }
}
