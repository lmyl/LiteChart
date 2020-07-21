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
        guard !self.funalFloorViews.isEmpty, self.bounds.size != .zero else {
            return
        }
        let fatherRect = self.bounds
        let floorViewHeight = fatherRect.height / CGFloat(self.funalFloorViews.count)
        var firstRect: CGRect? = nil
        for (index, floorView) in self.funalFloorViews.enumerated() {
            let originX = fatherRect.origin.x
            let originY = fatherRect.origin.y + CGFloat(index) * floorViewHeight
            let floorViewRect = CGRect(x: originX, y: originY, width: fatherRect.width, height: floorViewHeight)
            if let first = firstRect {
                self.updateFunalFloorViewConstraint(with: floorViewRect, from: first, funalFloorView: floorView)
            } else {
                self.updateFunalFloorViewConstraint(with: floorViewRect, from: floorViewRect, funalFloorView: floorView)
                firstRect = floorViewRect
            }
            
        }
    }
    
    private func updateFunalFloorViewConstraint(with rect: CGRect, from: CGRect, funalFloorView: FunalFloorView) {
        funalFloorView.snp.remakeConstraints{
            make in
            make.width.equalTo(from.width)
            make.height.equalTo(from.height)
            let centerX = from.origin.x + from.width / 2
            let centerY = from.origin.y + from.height / 2
            let center = CGPoint(x: centerX, y: centerY)
            make.center.equalTo(center)
        }
        
        UIView.animate(withDuration: 3, animations: {
            funalFloorView.snp.updateConstraints{
                make in
                let centerX = rect.origin.x + rect.width / 2
                let centerY = rect.origin.y + rect.height / 2
                let center = CGPoint(x: centerX, y: centerY)
                make.center.equalTo(center)
            }
            funalFloorView.layoutIfNeeded()
        }, completion: {
            print("Over\($0)")
        })
        
        print(funalFloorView.frame)
    }
}
