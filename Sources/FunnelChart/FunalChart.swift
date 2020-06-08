//
//  FunalChart.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/6.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit

class FunalChart: UIView {
    let configure: FunalChartConfigure
    
    var titleView: DisplayLabel?
    var funalView: FunalView?
    var legendViews: LegendViews?
    
    convenience init(parameter: FunalChartParameters) throws {
        try parameter.checkInputDatasParameterInvalid()
        let chartTitleConfigure = parameter.computeTitleConfigure()
        let funalViewConfigure = parameter.computeFunalViewComfigure()
        let legendViewsConfigure = parameter.computeLegendViewConfigure()
        let chartConfigure = FunalChartConfigure(funalViewConfigure: funalViewConfigure, chartTitleConfigure: chartTitleConfigure, legendViewsConfigure: legendViewsConfigure)
        self.init(configure: chartConfigure)
    }
    
    init(configure: FunalChartConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
        insertFunalView()
        insertTitleView()
        insertLegendViews()
    }
    
    required init?(coder: NSCoder) {
        self.configure = FunalChartConfigure()
        super.init(coder: coder)
        insertFunalView()
        insertTitleView()
        insertLegendViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateTitleViewConstraints()
        updateLegendViewsConstraints()
        updateFunalViewConstraints()
    }
    
    private func insertTitleView() {
        guard let titleConfigure = self.configure.chartTitleConfigure else {
            return
        }
        let titleView = DisplayLabel(configure: titleConfigure)
        self.addSubview(titleView)
        self.titleView = titleView
    }
    
    private func insertFunalView() {
        let funalView = FunalView(configure: self.configure.funalViewConfigure)
        self.addSubview(funalView)
        self.funalView = funalView
    }
    
    private func insertLegendViews() {
        guard let legendConfigure = self.configure.legendViewsConfigure else {
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
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(titleHeight)
        }
    }
    
    private func updateFunalViewConstraints() {
        guard let funalView = self.funalView else {
            return
        }
        var spaceHeight = self.bounds.height / 20
        spaceHeight = min(spaceHeight, 4)
        funalView.snp.updateConstraints{
            make in
            if let titleView = self.titleView {
                make.top.equalTo(titleView.snp.bottom).offset(spaceHeight)
            } else {
                make.top.equalToSuperview()
            }
            
            if let _ = self.legendViews {

            } else {
                make.right.equalToSuperview()
            }
            
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func updateLegendViewsConstraints() {
        guard let legendViews = self.legendViews else {
            return
        }
        guard let funalView = self.funalView else {
            return
        }
        var spaceWidth = self.bounds.width / 20
        spaceWidth = min(spaceWidth, 4)
        var legendViewsWidth = self.bounds.width / 5
        legendViewsWidth = min(legendViewsWidth, 100)
        legendViews.snp.updateConstraints{
            make in
            make.width.equalTo(legendViewsWidth)
            make.left.equalTo(funalView.snp.right).offset(spaceWidth)
            
            make.top.equalTo(funalView.snp.top)
            
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
