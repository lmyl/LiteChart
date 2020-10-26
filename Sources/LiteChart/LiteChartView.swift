//
//  LiteChartView.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/8.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit

public class LiteChartView: UIView {
    
    private var configure: LiteChartViewInterface
    
    private var contentView: LiteChartContentView?
    private var titleView: DisplayLabel?
    private var legendViews: UIView?
    private let syncCenter: DisplayLabelSyncCenter
    private let syncCenterIdentifier = UUID().uuidString
        
    public init(interface: LiteChartViewInterface) throws {
        self.configure = interface
        self.syncCenter = DisplayLabelSyncCenter(syncCenterIdentifier: syncCenterIdentifier)
        try self.configure.checkInputDatasParameterInvalid()
        super.init(frame: CGRect())
        
        insertTitleView()
        insertContentView()
        insertLegendViews()
        
        updateTitleViewStaticConstraints()
        updateContentViewStaticConstraints()
        updateLegendViewsStaticConstraints()
    }
    
    internal required init?(coder: NSCoder) {
        self.configure = LiteChartViewInterface.emptyInterface
        self.syncCenter = DisplayLabelSyncCenter(syncCenterIdentifier: syncCenterIdentifier)
        super.init(coder: coder)
        
        insertTitleView()
        insertContentView()
        insertLegendViews()
        
        updateTitleViewStaticConstraints()
        updateContentViewStaticConstraints()
        updateLegendViewsStaticConstraints()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        updateTitleViewDynamicConstraints()
        updateContentViewDynamicConstraints()
        updateLegendViewsDynamicConstraints()
    }
    
    private func insertTitleView() {
        if let title = self.titleView {
            title.removeFromSuperview()
            self.titleView = nil
        }
        guard let titleConfigure = self.configure.computeTitleConfigure() else {
            return
        }
        let titleView = DisplayLabel(configure: titleConfigure)
        self.addSubview(titleView)
        self.titleView = titleView
    }
    
    private func insertContentView() {
        if let content = self.contentView {
            content.removeFromSuperview()
            self.contentView = nil
        }
        let contentView = self.configure.computeContentView(syncCenterIdentifier: syncCenterIdentifier)
        self.addSubview(contentView)
        self.contentView = contentView
    }
    
    private func insertLegendViews() {
        if let legend = self.legendViews {
            legend.removeFromSuperview()
            self.legendViews = nil
        }
        guard let legendViews = self.configure.computeLegendViews(syncCenterIdentifier: syncCenterIdentifier) else {
            return
        }
        self.addSubview(legendViews)
        self.legendViews = legendViews
    }
    
    private var titleHeight: CGFloat {
        self.bounds.height / 10
    }
    
    private func updateTitleViewStaticConstraints() {
        guard let titleView = self.titleView, let content = self.contentView else {
            return
        }
        titleView.snp.remakeConstraints{
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
    }
    
    private func updateContentViewStaticConstraints() {
        guard let contentView = self.contentView else {
            return
        }
        contentView.snp.remakeConstraints{
            make in
            if let titleView = self.titleView {
                switch self.configure.chartTitleDisplayLocation {
                case .top:
                    make.top.equalTo(titleView.snp.bottom).priority(750)
                    make.bottom.equalToSuperview()
                case .bottom:
                    make.top.equalToSuperview()
                    make.bottom.equalTo(titleView.snp.top).priority(750)
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
        legendViews.snp.remakeConstraints{
            make in
            make.width.equalToSuperview().multipliedBy(0.2)
            make.leading.equalTo(contentView.snp.trailing).priority(750)
            
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
            make.leading.equalTo(contentView.snp.trailing).offset(spaceWidth).priority(750)
        }
    }
}

extension LiteChartView: LiteChartAnimatable {
    public var animationStatus: LiteChartAnimationStatus {
        self.contentView?.animationStatus ?? .ready
    }
    
    public func startAnimation(animation: LiteChartAnimationInterface) {
        self.contentView?.startAnimation(animation: animation)
    }
    
    public func pauseAnimation() {
        self.contentView?.pauseAnimation()
    }
    
    public func stopAnimation() {
        self.contentView?.stopAnimation()
    }
    
    public func continueAnimation() {
        self.contentView?.continueAnimation()
    }
}
