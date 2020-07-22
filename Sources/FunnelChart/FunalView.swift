//
//  FunalView.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/5.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit

class FunalView: UIView {
    private var configure: FunalViewConfigure
    private var funalFloorViews: [FunalFloorView] = []
    
    init(configure: FunalViewConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
        self.insertFunalFloorViews()
    }
    
    required init?(coder: NSCoder) {
        self.configure = .emptyconfigure
        super.init(coder: coder)
        self.insertFunalFloorViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateFunalFloorViewsConstraint()
    }
    
    private func insertFunalFloorViews() {
        for view in self.funalFloorViews {
            view.removeFromSuperview()
        }
        self.funalFloorViews = []
        for configure in self.configure.models {
            let floorView = FunalFloorView(configure: configure)
            self.addSubview(floorView)
            self.funalFloorViews.append(floorView)
        }
    }
    
    private func updateFunalFloorViewsConstraint() {
        guard !self.funalFloorViews.isEmpty else {
            return
        }
        let fatherRect = self.bounds
        let floorViewHeight = fatherRect.height / CGFloat(self.funalFloorViews.count)
        for (index, floorView) in self.funalFloorViews.enumerated() {
            let originX = fatherRect.origin.x
            let originY = fatherRect.origin.y + CGFloat(index) * floorViewHeight
            let floorViewRect = CGRect(x: originX, y: originY, width: fatherRect.width, height: floorViewHeight)
            self.updateFunalFloorViewDynamicConstraint(with: floorViewRect, funalFloorView: floorView)
        }
    }
    
    
    private func updateFunalFloorViewDynamicConstraint(with rect: CGRect, funalFloorView: FunalFloorView) {
        funalFloorView.snp.updateConstraints{
            make in
            make.width.equalTo(rect.width)
            make.height.equalTo(rect.height)
            let centerX = rect.origin.x + rect.width / 2
            let centerY = rect.origin.y + rect.height / 2
            let center = CGPoint(x: centerX, y: centerY)
            make.center.equalTo(center)
        }
    }
}
