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
    let configure: PointViewsConfigure
    
    var pointsView: [PointsView] = []
    
    init(configure: PointViewsConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
        insertPointsView()
    }
    
    required init?(coder: NSCoder) {
        self.configure = PointViewsConfigure()
        super.init(coder: coder)
        insertPointsView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updatePointsViewConstraints()
    }
    
    private func insertPointsView() {
        for configure in self.configure.models {
            let view = PointsView(configure: configure)
            self.addSubview(view)
            self.pointsView.append(view)
        }
    }
    
    private func updatePointsViewConstraints() {
        for view in self.pointsView {
            view.snp.updateConstraints{
                make in
                make.center.equalToSuperview()
                make.width.equalToSuperview()
                make.height.equalToSuperview()
            }
        }
    }
}
