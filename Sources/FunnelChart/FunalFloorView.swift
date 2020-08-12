//
//  FunalFloorView.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/5.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit
import SnapKit

class FunalFloorView: UIView {
    
    private var configure: FunalFloorViewConfigure
    private var backgroundView: FunalFloorBackagroundView?
    private var contentView: DisplayLabel?
    
    init(configure: FunalFloorViewConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
        self.insertBackgroundView()
        self.insertContentView()
        
        updateBackgroundViewStaticConstraint()
        updateContentViewWithStaticConstraint()
    }
    
    required init?(coder: NSCoder) {
        self.configure = .emptyConfigure
        super.init(coder: coder)
        self.insertBackgroundView()
        self.insertContentView()
        
        updateBackgroundViewStaticConstraint()
        updateContentViewWithStaticConstraint()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateContentViewWithDynamicConstraint()
    }
    
    private func insertBackgroundView() {
        if let backgroundView = self.backgroundView {
            backgroundView.removeFromSuperview()
            self.backgroundView = nil
        }
        let backgroundView = FunalFloorBackagroundView(configure: self.configure.backgroundViewConfigure)
        self.addSubview(backgroundView)
        self.backgroundView = backgroundView
    }
    
    private func insertContentView() {
        if let contentView = self.contentView {
            contentView.removeFromSuperview()
            self.contentView = nil
        }
        guard self.configure.isShowLabel else {
            return
        }
        let contentView = DisplayLabel(configure: self.configure.contentViewConfigure)
        self.addSubview(contentView)
        self.contentView = contentView
    }
    
    private func updateBackgroundViewStaticConstraint() {
        guard let backgroundView = self.backgroundView else {
            return
        }
        backgroundView.snp.remakeConstraints{
            make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
    private func updateContentViewWithStaticConstraint() {
        guard let contentView = self.contentView else {
            return
        }
        contentView.snp.remakeConstraints{
            make in
            make.width.equalToSuperview().multipliedBy(0.2)
            make.center.equalToSuperview()
            make.height.equalTo(0)
        }
    }
    
    private func updateContentViewWithDynamicConstraint() {
        guard let contentView = self.contentView else {
            return
        }
        var height = self.bounds.height / 2
        height = min(height, 20)
        contentView.snp.updateConstraints{
            make in
            make.height.equalTo(height)
        }
    }
}
