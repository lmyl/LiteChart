//
//  PointViews.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/20.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit
import SnapKit

class PointViews: UIView {
    private let configure: PointViewsConfigure
    
    private var pointsView: [PointsView] = []
    
    init(configure: PointViewsConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
        insertPointsView()
        
        updatePointsViewStaticConstraints()
    }
    
    required init?(coder: NSCoder) {
        self.configure = PointViewsConfigure.emptyConfigure
        super.init(coder: coder)
        insertPointsView()
        
        updatePointsViewStaticConstraints()
    }
    
    private func insertPointsView() {
        for view in self.pointsView {
            view.removeFromSuperview()
        }
        self.pointsView = []
        for configure in self.configure.models {
            let view = PointsView(configure: configure)
            self.addSubview(view)
            self.pointsView.append(view)
        }
    }
    
    private func updatePointsViewStaticConstraints() {
        for view in self.pointsView {
            view.snp.remakeConstraints{
                make in
                make.leading.trailing.top.bottom.equalToSuperview()
            }
        }
    }
}
