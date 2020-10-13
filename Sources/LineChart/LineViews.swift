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
    private var lineValueView: LineValueView?
    
    init(configure: LineViewsConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
        self.insertLineViews()
        self.insertLineValueView()
        
        updateLineViewsStaticConstraints()
        updateLineValueViewStaticConstraints()
    }
    
    required init?(coder: NSCoder) {
        self.configure = LineViewsConfigure.emptyConfigure
        super.init(coder: coder)
        self.insertLineViews()
        self.insertLineValueView()
        
        updateLineViewsStaticConstraints()
        updateLineValueViewStaticConstraints()
    }
    
    private func insertLineViews() {
        for model in self.configure.models {
            let line = LineView(configure: model)
            self.addSubview(line)
            self.lineViews.append(line)
        }
    }
    
    private func insertLineValueView() {
        guard self.configure.isShowLabel else {
            return
        }
        let lineValues = LineValueView(configure: self.configure.valueModel)
        self.lineValueView = lineValues
        self.addSubview(lineValues)
        self.bringSubviewToFront(lineValues)
    }
    
    private func updateLineValueViewStaticConstraints() {
        guard let lineValue = self.lineValueView else {
            return
        }
        lineValue.snp.remakeConstraints({
            make in
            make.trailing.leading.bottom.top.equalToSuperview()
        })
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
