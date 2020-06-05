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
    
    var configure: FunalFloorViewConfigure
    private var backgroundView: FunalFloorBackagroundView?
    private var contentView: DisplayLabel?
    
    init(configure: FunalFloorViewConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
        self.insertBackgroundView()
        self.insertContentView()
    }
    
    required init?(coder: NSCoder) {
        self.configure = FunalFloorViewConfigure()
        super.init(coder: coder)
        self.insertBackgroundView()
        self.insertContentView()
    }
    
    override func layoutSubviews() {
        superview?.layoutSubviews()
        updateBackgroundViewConstraint()
        updateContentViewConstraint()
    }
    
    private func insertBackgroundView() {
        let backgroundView = FunalFloorBackagroundView(configure: self.configure.backgroundViewConfigure)
        self.addSubview(backgroundView)
        self.backgroundView = backgroundView
    }
    
    private func insertContentView() {
        guard let contentViewConfigure = self.configure.contentViewConfigure else {
            return
        }
        let contentView = DisplayLabel(configure: contentViewConfigure)
        self.addSubview(contentView)
        self.contentView = contentView
    }
    
    private func updateBackgroundViewConstraint() {
        guard let backgroundView = self.backgroundView else {
            return
        }
        backgroundView.snp.updateConstraints{
            make in
            make.size.equalToSuperview()
            make.center.equalToSuperview()
        }
    }
    
    private func updateContentViewConstraint() {
        guard let contentView = self.contentView else {
            return
        }
        contentView.snp.updateConstraints{
            make in
            let width = self.bounds.width / 5
            var height = self.bounds.height / 2
            height = min(height, 20)
            make.width.equalTo(width)
            make.height.equalTo(height)
            make.center.equalToSuperview()
        }
    }
}
