//
//  LiteChartView.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/8.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit

class LiteChartView: UIView {
    
    var configure: LiteChartViewParameters
    
    var contentView: UIView?
    var titleView: DisplayLabel?
    var legendViews: LegendViews?
    
    init(configure: LiteChartViewParameters) throws {
        self.configure = configure
        try self.configure.checkInputDatasParameterInvalid()
        super.init(frame: CGRect())
        insertTitleView()
        insertContentView()
        insertLegendViews()
    }
    
    required init?(coder: NSCoder) {
        self.configure = LiteChartViewParameters()
        super.init(coder: coder)
        insertTitleView()
        insertContentView()
        insertLegendViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateTitleViewConstraints()
        updateContentViewConstraints()
        updateLegendViewsConstraints()
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
        guard self.configure.isShowLegendTitles, let legendConfigure = self.configure.computeLegendViewConfigure() else {
            return
        }
        let legendViews = LegendViews(configure: legendConfigure)
        self.addSubview(legendViews)
        self.legendViews = legendViews
    }
    
    
    private func updateTitleViewConstraints() {
        guard let titleView = self.titleView else {
            return
        }
        var titleHeight = self.bounds.height / 10
        titleHeight = min(titleHeight, 20)
        titleView.snp.updateConstraints{
            make in
            switch self.configure.titleDisplayLocation {
            case .top:
                make.top.equalToSuperview()
            case .bottom:
                make.bottom.equalToSuperview()
            }
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(titleHeight)
        }
    }
    
    private func updateContentViewConstraints() {
        guard let contentView = self.contentView else {
            return
        }
        var spaceHeight = self.bounds.height / 20
        spaceHeight = min(spaceHeight, 4)
        contentView.snp.updateConstraints{
            make in
            if let titleView = self.titleView {
                switch self.configure.titleDisplayLocation {
                case .top:
                    make.top.equalTo(titleView.snp.bottom).offset(spaceHeight)
                    make.bottom.equalToSuperview()
                case .bottom:
                    make.top.equalToSuperview()
                    make.bottom.equalTo(titleView.snp.top).offset(0 - spaceHeight)
                }
            } else {
                make.top.equalToSuperview()
                make.bottom.equalToSuperview()
            }
            
            if let _ = self.legendViews {

            } else {
                make.right.equalToSuperview()
            }
            
            make.left.equalToSuperview()
        }
    }
    
    private func updateLegendViewsConstraints() {
        guard let legendViews = self.legendViews else {
            return
        }
        guard let contentView = self.contentView else {
            return
        }
        var spaceWidth = self.bounds.width / 20
        spaceWidth = min(spaceWidth, 4)
        var legendViewsWidth = self.bounds.width / 5
        legendViewsWidth = min(legendViewsWidth, 100)
        legendViews.snp.updateConstraints{
            make in
            make.width.equalTo(legendViewsWidth)
            make.left.equalTo(contentView.snp.right).offset(spaceWidth)
            
            make.top.equalTo(contentView.snp.top)
            
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
