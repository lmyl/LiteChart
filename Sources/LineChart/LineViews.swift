//
//  LineViews.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/17.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit
import SnapKit

class LineViews: UIView {
    let configure: LineViewsConfigure
    
    var lineViews: [LineView] = []
    
    init(configure: LineViewsConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
        self.insertLineViews()
    }
    
    required init?(coder: NSCoder) {
        self.configure = LineViewsConfigure()
        super.init(coder: coder)
        self.insertLineViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateLineViewsConstraints()
    }
    
    private func insertLineViews() {
        for model in self.configure.models {
            let line = LineView(configure: model)
            self.addSubview(line)
            self.lineViews.append(line)
        }
    }
    
    private func updateLineViewsConstraints() {
        for line in self.lineViews {
            line.snp.updateConstraints{
                make in
                make.center.equalToSuperview()
                make.width.equalToSuperview()
                make.height.equalToSuperview()
            }
        }
    }
    
}
