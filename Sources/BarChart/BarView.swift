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
    let configure: BarViewConfigure
    
    private var bar: UIView?
    private var label: DisplayLabel?
    
    init(configure: BarViewConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
        insertBar()
        insertLabel()
    }
    
    required init?(coder: NSCoder) {
        self.configure = BarViewConfigure()
        super.init(coder: coder)
        insertBar()
        insertLabel()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateBarConstraints()
        updateLabelConstraints()
    }
    
    private func insertBar() {
        let bar = UIView()
        bar.backgroundColor = self.configure.barColor.color
        self.bar = bar
        self.addSubview(bar)
    }
    
    
    private func insertLabel() {
        guard let labelConfigure = self.configure.label else {
            return
        }
        let label = DisplayLabel(configure: labelConfigure)
        self.addSubview(label)
        self.label = label
    }
    
    private func updateBarConstraints() {
        guard let bar = self.bar else {
            return
        }
        bar.backgroundColor = self.configure.barColor.color
        
        switch self.configure.direction {
        case .bottomToTop:
            let length = self.bounds.height * self.configure.length
            bar.snp.updateConstraints{
                make in
                make.bottom.equalToSuperview()
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                make.height.equalTo(length)
            }
        case .leftToRight:
            let length = self.bounds.width * self.configure.length
            bar.snp.updateConstraints{
                make in
                make.bottom.equalToSuperview()
                make.left.equalToSuperview()
                make.width.equalTo(length)
                make.top.equalToSuperview()
            }
        }
        
    }
    
    private func updateLabelConstraints() {
        guard let label = self.label else {
            return
        }
        guard let bar = self.bar else {
            return
        }
        switch self.configure.direction {
        case .bottomToTop:
            var space = self.bounds.height / 20
            space = min(space, 4)
            var height = self.bounds.height / 10
            height = min(height, 20)
            label.snp.updateConstraints{
                make in
                make.bottom.equalTo(bar.snp.top).offset(0 - space)
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                make.height.equalTo(height)
            }
        case .leftToRight:
            var space = self.bounds.width / 20
            space = min(space, 4)
            var length = self.bounds.width / 10
            length = min(length, 20)
            label.snp.updateConstraints{
                make in
                make.bottom.equalToSuperview()
                make.left.equalTo(bar.snp.right).offset(space)
                make.width.equalTo(length)
                make.height.equalToSuperview()
            }
        }
        
    }
    
}
