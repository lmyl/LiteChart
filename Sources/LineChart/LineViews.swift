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
    private let configure: LineViewsConfigure
    
    private var lineViews: [LineView] = []
    
    init(configure: LineViewsConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
        self.insertLineViews()
        
        updateLineViewsStaticConstraints()
    }
    
    required init?(coder: NSCoder) {
        self.configure = LineViewsConfigure.emptyConfigure
        super.init(coder: coder)
        self.insertLineViews()
        
        updateLineViewsStaticConstraints()
    }
    
    private func insertLineViews() {
        for model in self.configure.models {
            let line = LineView(configure: model)
            self.addSubview(line)
            self.lineViews.append(line)
        }
    }
    
    private func updateLineViewsStaticConstraints() {
        for line in self.lineViews {
            line.snp.updateConstraints{
                make in
                make.trailing.leading.bottom.top.equalToSuperview()
            }
        }
    }
    
}
