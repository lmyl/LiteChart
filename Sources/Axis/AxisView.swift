//
//  AxisView.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/10.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit
import SnapKit

class AxisView: UIView {
    private let configure: AxisViewConfigure
    private let borderMaskLayer = CAShapeLayer()
    private let contentLayer = CAShapeLayer()
    private let borderDelegate: AxisViewBorderMaskLayerDelegate
    private let contentDelegate: AxisViewContentLayerDelegate
        
    init(configure: AxisViewConfigure) {
        self.configure = configure
        self.borderDelegate = AxisViewBorderMaskLayerDelegate(borderColor: configure.borderColor, borderStyle: configure.borderStyle, borderWidth: 1)
        self.contentDelegate = AxisViewContentLayerDelegate(verticalDividingPoints: configure.verticalDividingPoints, horizontalDividingPoints: configure.horizontalDividingPoints, originPoint: configure.originPoint, axisColor: configure.axisColor, isShowXAxis: configure.isShowXAxis, isShowYAxis: configure.isShowYAxis)
        super.init(frame: CGRect())
        self.borderMaskLayer.delegate = self.borderDelegate
        self.contentLayer.delegate = self.contentDelegate
        self.layer.addSublayer(self.contentLayer)
        self.layer.borderWidth = 1
        self.layer.borderColor = self.configure.borderColor.color.cgColor
        self.layer.mask = borderMaskLayer
    }
    
    required init?(coder: NSCoder) {
        self.configure = AxisViewConfigure.emptyConfigure
        self.borderDelegate = AxisViewBorderMaskLayerDelegate(borderColor: configure.borderColor, borderStyle: configure.borderStyle, borderWidth: 1)
        self.contentDelegate = AxisViewContentLayerDelegate(verticalDividingPoints: configure.verticalDividingPoints, horizontalDividingPoints: configure.horizontalDividingPoints, originPoint: configure.originPoint, axisColor: configure.axisColor, isShowXAxis: configure.isShowXAxis, isShowYAxis: configure.isShowYAxis)
        super.init(frame: CGRect())
        self.borderMaskLayer.delegate = self.borderDelegate
        self.contentLayer.delegate = self.contentDelegate
        self.layer.addSublayer(self.contentLayer)
        self.layer.borderWidth = 1
        self.layer.borderColor = self.configure.borderColor.color.cgColor
        self.layer.mask = borderMaskLayer
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.borderMaskLayer.setNeedsDisplay()
        self.contentLayer.setNeedsDisplay()
    }
}
