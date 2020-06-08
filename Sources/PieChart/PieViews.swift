//
//  PieViews.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/8.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit

class PieViews: UIView {
    let configure: PieViewsConfigure
    
    var pieViews: [PieView] = []
    
    init(configure: PieViewsConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
        insertPieView()
    }
    
    required init?(coder: NSCoder) {
        self.configure = PieViewsConfigure()
        super.init(coder: coder)
        insertPieView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updatePieViewsConstraints()
    }
    
    private func insertPieView() {
        for pieConfigure in self.configure.models {
            let pie = PieView(configure: pieConfigure)
            self.addSubview(pie)
            self.pieViews.append(pie)
        }
    }
    
    private func updatePieViewsConstraints() {
        for pie in self.pieViews {
            pie.snp.updateConstraints{
                make in
                make.center.equalToSuperview()
                make.width.equalToSuperview()
                make.height.equalToSuperview()
            }
        }
    }
}
