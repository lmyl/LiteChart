//
//  LiteChartView.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/8.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit

class LiteChartView: UIView {
    
    private var configure: LiteChartViewInterface
    
    private var contentView: LiteChartContentView?
    private var titleView: DisplayLabel?
    private var legendViews: UIView?
        
    init(interface: LiteChartViewInterface) throws {
        self.configure = interface
        try self.configure.contentInterface.parametersProcesser.checkInputDatasParameterInvalid()
        super.init(frame: CGRect())
        
        let _ = DisplayLabelSyncCenter.shared
        
        insertTitleView()
        insertContentView()
        insertLegendViews()
        
        updateTitleViewStaticConstraints()
        updateContentViewStaticConstraints()
        updateLegendViewsStaticConstraints()
    }
    
    required init?(coder: NSCoder) {
        self.configure = LiteChartViewInterface.emptyInterface
        super.init(coder: coder)
        
        let _ = DisplayLabelSyncCenter.shared
        insertTitleView()
        insertContentView()
        insertLegendViews()
        
        updateTitleViewStaticConstraints()
        updateContentViewStaticConstraints()
        updateLegendViewsStaticConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateTitleViewDynamicConstraints()
        updateContentViewDynamicConstraints()
        updateLegendViewsDynamicConstraints()
    }
    
    private func insertTitleView() {
        guard let titleConfigure = self.configure.computeTitleConfigure() else {
            return
        }
        let titleView = DisplayLabel(configure: titleConfigure)
        self.addSubview(titleView)
        self.titleView = titleView
    }
    
    private func insertContentView() {
        let contentView = self.configure.computeContentView()
        self.addSubview(contentView)
        self.contentView = contentView
    }
    
    private func insertLegendViews() {
        guard let legendViews = self.configure.computeLegendViews() else {
            return
        }
        self.addSubview(legendViews)
        self.legendViews = legendViews
    }
    
    var titleHeight: CGFloat {
        self.bounds.height / 10
    }
    
    private func updateTitleViewStaticConstraints() {
        guard let titleView = self.titleView, let content = self.contentView else {
            return
        }
        titleView.snp.updateConstraints{
            make in
            switch self.configure.chartTitleDisplayLocation {
            case .top:
                make.top.equalToSuperview()
            case .bottom:
                make.bottom.equalToSuperview()
            }
            make.leading.equalTo(content.areaLayoutGuide.snp.leading)
            make.trailing.equalTo(content.areaLayoutGuide.snp.trailing)
            make.height.equalTo(titleHeight)
        }
    }
    
    private func updateTitleViewDynamicConstraints() {
        guard let titleView = self.titleView else {
            return
        }
        titleView.snp.updateConstraints{
            make in
            make.height.equalTo(titleHeight)
        }
        titleView.layer.setNeedsDisplay()
    }
    
    private func updateContentViewStaticConstraints() {
        guard let contentView = self.contentView else {
            return
        }
        contentView.snp.updateConstraints{
            make in
            if let titleView = self.titleView {
                switch self.configure.chartTitleDisplayLocation {
                case .top:
                    make.top.equalTo(titleView.snp.bottom).priority(750)
                    make.bottom.equalToSuperview().priority(750)
                case .bottom:
                    make.top.equalToSuperview().priority(750)
                    make.bottom.equalTo(titleView.snp.top).priority(750)
                }
            } else {
                make.top.equalToSuperview().priority(750)
                make.bottom.equalToSuperview().priority(750)
            }
            
            if self.legendViews == nil {
                make.trailing.equalToSuperview().priority(750)
            }
            
            make.leading.equalToSuperview().priority(750)
        }
    }
    
    private func updateContentViewDynamicConstraints() {
        guard let contentView = self.contentView else {
            return
        }
        let spaceHeight = titleHeight
        contentView.snp.updateConstraints{
            make in
            if let titleView = self.titleView {
                switch self.configure.chartTitleDisplayLocation {
                case .top:
                    make.top.equalTo(titleView.snp.bottom).offset(spaceHeight / 2).priority(750)
                case .bottom:
                    make.bottom.equalTo(titleView.snp.top).offset(0 - spaceHeight / 2).priority(750)
                }
            }
        }
    }
    
    private func updateLegendViewsStaticConstraints() {
        guard let legendViews = self.legendViews else {
            return
        }
        guard let contentView = self.contentView else {
            return
        }
        legendViews.snp.updateConstraints{
            make in
            make.width.equalToSuperview().multipliedBy(0.2)
            make.leading.equalTo(contentView.snp.trailing)
            
            make.top.equalTo(contentView.snp.top)
            
            make.trailing.equalToSuperview()
            make.bottom.equalTo(contentView.snp.bottom)
        }
    }
    
    private func updateLegendViewsDynamicConstraints() {
        guard let legendViews = self.legendViews else {
            return
        }
        guard let contentView = self.contentView else {
            return
        }
        let spaceWidth = self.bounds.width / 45
        legendViews.snp.updateConstraints{
            make in
            make.leading.equalTo(contentView.snp.trailing).offset(spaceWidth)
        }
    }
}
