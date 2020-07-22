//
//  PieViews.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/8.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit

class PieViews: UIView {
    private let configure: PieViewsConfigure
    
    private var pieViews: [PieView] = []
    
    init(configure: PieViewsConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
        insertPieView()
        
        updatePieViewsStaticConstraints()
    }
    
    required init?(coder: NSCoder) {
        self.configure = PieViewsConfigure.emptyConfigure
        super.init(coder: coder)
        insertPieView()
        
        updatePieViewsStaticConstraints()
    }
    
    private func insertPieView() {
        for pieConfigure in self.configure.models {
            let pie = PieView(configure: pieConfigure)
            self.addSubview(pie)
            self.pieViews.append(pie)
        }
    }
    
    private func updatePieViewsStaticConstraints() {
        for pie in self.pieViews {
            pie.snp.remakeConstraints{
                make in
                make.center.equalToSuperview()
                make.width.equalToSuperview()
                make.height.equalToSuperview()
            }
        }
    }
}
