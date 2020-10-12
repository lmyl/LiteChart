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
    
    private var contentView: UIView?
    private var titleView: DisplayLabel?
    private var legendViews: LegendViews?
    
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
        guard let legendConfigure = self.configure.computeLegendViewConfigure() else {
            return
        }
        let legendViews = LegendViews(configure: legendConfigure)
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
            make.leading.equalTo(content.snp.leading)
            make.trailing.equalTo(content.snp.trailing)
            make.height.equalTo(titleHeight)
        }
    }
    
    private func updateTitleViewDynamicConstraints() {
        guard let titleView = self.titleView else {
            return
        }
        let spaceHeight = titleHeight / 2
        titleView.snp.updateConstraints{
            make in
            switch self.configure.chartTitleDisplayLocation {
            case .top:
                make.top.equalToSuperview().offset(spaceHeight)
            case .bottom:
                make.bottom.equalToSuperview().offset(-spaceHeight)
            }
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
                    make.top.equalTo(titleView.snp.bottom)
                    make.bottom.equalToSuperview()
                case .bottom:
                    make.top.equalToSuperview()
                    make.bottom.equalTo(titleView.snp.top)
                }
            } else {
                make.top.equalToSuperview()
                make.bottom.equalToSuperview()
            }
            
            if self.legendViews == nil {
                make.trailing.equalToSuperview()
            }
            
            make.leading.equalToSuperview()
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
                    make.top.equalTo(titleView.snp.bottom).offset(spaceHeight / 2)
                    make.bottom.equalToSuperview().offset(-spaceHeight)
                case .bottom:
                    make.bottom.equalTo(titleView.snp.top).offset(0 - spaceHeight / 2)
                    make.top.equalToSuperview().offset(spaceHeight)
                }
            } else {
                make.top.equalToSuperview().offset(spaceHeight)
                make.bottom.equalToSuperview().offset(-spaceHeight)
            }
            if self.legendViews == nil {
                make.trailing.equalToSuperview().offset(-spaceHeight)
            }
            make.leading.equalToSuperview().offset(spaceHeight)
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
