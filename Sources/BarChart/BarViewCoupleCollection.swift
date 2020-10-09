//
//  BarViewCoupleCollection.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/9/30.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class BarViewCoupleCollection: UIView {
    let configure: BarViewCoupleCollectionConfigure
    
    var barViewCoupleViews: [BarViewCouple] = []
    
    init(configure: BarViewCoupleCollectionConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
        
        insertBarViewCoupleView()
        updateBarViewCoupleViewStaticConstraints()
    }
    
    
    required init?(coder: NSCoder) {
        self.configure = BarViewCoupleCollectionConfigure.emptyConfigure
        super.init(coder: coder)
        
        insertBarViewCoupleView()
        updateBarViewCoupleViewStaticConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateBarViewCoupleViewDynamicConstraints()
    }
    
    private func insertBarViewCoupleView() {
        for configure in self.configure.models {
            let view = BarViewCouple(configure: configure)
            self.addSubview(view)
            self.barViewCoupleViews.append(view)
        }
    }
    
    private func updateBarViewCoupleViewStaticConstraints() {
        let itemCount = self.barViewCoupleViews.count
        guard itemCount > 0 else {
            return
        }
        
        var frontView: BarViewCouple?
        
        switch self.configure.direction {
        case .bottomToTop:
            for barView in self.barViewCoupleViews {
                guard let front = frontView else {
                    barView.snp.updateConstraints{
                        make in
                        make.leading.equalToSuperview()
                        make.width.equalTo(0)
                        make.bottom.equalToSuperview()
                        make.top.equalToSuperview()
                    }
                    frontView = barView
                    continue
                }
                barView.snp.updateConstraints{
                    make in
                    make.leading.equalTo(front.snp.trailing)
                    make.width.equalTo(front.snp.width)
                    make.bottom.equalToSuperview()
                    make.top.equalToSuperview()
                }
                frontView = barView
            }
        case .leftToRight:
            for barView in self.barViewCoupleViews {
                guard let front = frontView else {
                    barView.snp.updateConstraints{
                        make in
                        make.leading.equalToSuperview()
                        make.height.equalTo(0)
                        make.bottom.equalToSuperview()
                        make.trailing.equalToSuperview()
                    }
                    frontView = barView
                    continue
                }
                barView.snp.updateConstraints{
                    make in
                    make.leading.equalToSuperview()
                    make.height.equalTo(front.snp.height)
                    make.bottom.equalTo(front.snp.top)
                    make.trailing.equalToSuperview()
                }
                frontView = barView
            }
        }
    }
    
    private func updateBarViewCoupleViewDynamicConstraints() {
        let itemCount = self.barViewCoupleViews.count
        guard itemCount > 0 else {
            return
        }
        guard let first = self.barViewCoupleViews.first else {
            return
        }
        switch self.configure.direction {
        case .bottomToTop:
            let itemWidth = self.bounds.width / CGFloat(itemCount)
            first.snp.updateConstraints{
                make in
                make.width.equalTo(itemWidth)
            }
        case .leftToRight:
            let itemHeight = self.bounds.height / CGFloat(itemCount)
            first.snp.updateConstraints{
                make in
                make.height.equalTo(itemHeight)
            }
        }
    }
}
