//
//  BarView.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/11.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit
import SnapKit

class BarView: UIView {
    private let configure: BarViewConfigure
    
    private var bar: UIView?
    private var label: DisplayLabel?
    
    init(configure: BarViewConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
        insertBar()
        insertLabel()
        
        updateBarStaticConstrints()
        updateLabelStaticConstraints()
    }
    
    required init?(coder: NSCoder) {
        self.configure = BarViewConfigure.emptyConfigure
        super.init(coder: coder)
        insertBar()
        insertLabel()
        
        updateBarStaticConstrints()
        updateLabelStaticConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateBarDynamicConstraints()
        updateLabelDynamicConstraints()
    }
    
    private func insertBar() {
        let bar = UIView()
        bar.backgroundColor = self.configure.barColor.color
        self.bar = bar
        self.addSubview(bar)
    }
    
    
    private func insertLabel() {
        guard self.configure.isShowLabel else {
            return
        }
        let label = DisplayLabel(configure: self.configure.label)
        self.addSubview(label)
        self.label = label
    }
    
    private func updateBarDynamicConstraints() {
        guard let bar = self.bar else {
            return
        }
        bar.backgroundColor = self.configure.barColor.color
        switch self.configure.direction {
        case .bottomToTop:
            let length = self.bounds.height * self.configure.length
            bar.snp.updateConstraints{
                make in
                make.height.equalTo(length)
            }
        case .leftToRight:
            let length = self.bounds.width * self.configure.length
            bar.snp.updateConstraints{
                make in
                make.width.equalTo(length)
            }
        }
        
    }
    
    private func updateBarStaticConstrints() {
        guard let bar = self.bar else {
            return
        }
        bar.backgroundColor = self.configure.barColor.color
        switch self.configure.direction {
        case .bottomToTop:
            bar.snp.updateConstraints{
                make in
                make.bottom.equalToSuperview()
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.height.equalTo(0)
            }
        case .leftToRight:
            bar.snp.updateConstraints{
                make in
                make.bottom.equalToSuperview()
                make.leading.equalToSuperview()
                make.width.equalTo(0)
                make.top.equalToSuperview()
            }
        }
    }
    
    private func updateLabelStaticConstraints() {
        guard let label = self.label else {
            return
        }
        guard let bar = self.bar else {
            return
        }
        switch self.configure.direction {
        case .bottomToTop:
            label.snp.updateConstraints{
                make in
                make.bottom.equalTo(bar.snp.top)
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.height.equalTo(0)
            }
        case .leftToRight:
            label.snp.updateConstraints{
                make in
                make.bottom.equalToSuperview()
                make.leading.equalTo(bar.snp.trailing)
                make.trailing.equalToSuperview()
                make.height.equalToSuperview()
            }
        }
    }
    
    private func updateLabelDynamicConstraints() {
        guard let label = self.label else {
            return
        }
        guard let bar = self.bar else {
            return
        }
        switch self.configure.direction {
        case .bottomToTop:
            var height = self.bounds.height / 15
            height = min(height, self.bounds.width * 2)
            label.snp.updateConstraints{
                make in
                make.bottom.equalTo(bar.snp.top)
                make.height.equalTo(height)
            }
        case .leftToRight:
            let space = self.bounds.width / 30
            label.snp.updateConstraints{
                make in
                make.leading.equalTo(bar.snp.trailing).offset(space)
            }
        }
        
    }
    
}
