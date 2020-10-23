//
//  PieViews.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/8.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit

class PieViews: LiteChartContentView {
    private let configure: PieViewsConfigure
    
    private var pieValueView: PieValueView?
            
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
    
    override func layoutSubviews() {
        stopAnimation()
        
        super.layoutSubviews()
    }
    
    private func insertPieView() {
        if let pie = self.pieValueView {
            pie.removeFromSuperview()
            self.pieValueView = nil
        }
        let pie = PieValueView(configure: self.configure.model)
        self.addSubview(pie)
        self.pieValueView = pie
    }
    
    private func updatePieViewsStaticConstraints() {
        guard let pie = self.pieValueView else {
            return
        }
        pie.snp.remakeConstraints{
            make in
            make.trailing.leading.top.bottom.equalToSuperview()
        }
    }
    
    override func startAnimation(animation: LiteChartAnimationInterface) {
        self.pieValueView?.startAnimation(animation: animation)
    }
    
    override func pauseAnimation() {
        self.pieValueView?.pauseAnimation()
    }
    
    override func stopAnimation() {
        self.pieValueView?.stopAnimation()
    }
    
    override func continueAnimation() {
        self.pieValueView?.continueAnimation()
    }
    
    override var animationStatus: LiteChartAnimationStatus {
        self.pieValueView?.animationStatus ?? .ready
    }
}
