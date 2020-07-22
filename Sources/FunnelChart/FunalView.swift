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
        
        updateFunalFloorViewStaticConstraint()
    }
    
    required init?(coder: NSCoder) {
        self.configure = .emptyconfigure
        super.init(coder: coder)
        self.insertFunalFloorViews()
        
        updateFunalFloorViewStaticConstraint()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateFunalFloorViewDynamicConstraint()
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
    
    private func updateFunalFloorViewDynamicConstraint() {
        guard !self.funalFloorViews.isEmpty else {
            return
        }
        let fatherRect = self.bounds
        let floorViewHeight = fatherRect.height / CGFloat(self.funalFloorViews.count)
        for (index, floorView) in self.funalFloorViews.enumerated() {
            let originY = fatherRect.origin.y + CGFloat(index) * floorViewHeight
            let centerY = originY + fatherRect.height / 2
            floorView.snp.updateConstraints{
                make in
                make.centerY.equalTo(centerY)
                make.height.equalTo(floorViewHeight)
            }
        }
    }
    
    private func updateFunalFloorViewStaticConstraint() {
        for floorView in self.funalFloorViews {
            floorView.snp.remakeConstraints{
                make in
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.height.equalTo(0)
                make.centerY.equalTo(0)
            }
        }
    }
}
