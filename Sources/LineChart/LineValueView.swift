//
//  LineValueView.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/10/13.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class LineValueView: UIView {
    private let configure: LineValueViewConfigure
    
    private var valuesView: [[DisplayLabel]] = []
    
    init(configure: LineValueViewConfigure) {
        self.configure = configure
        super.init(frame: .zero)
        insertValueView()
    }
    
    required init?(coder: NSCoder) {
        self.configure = .emptyConfigure
        super.init(coder: coder)
        insertValueView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateValueViewsDynamicConstraints()
    }
    
    private func insertValueView() {
        for label in self.valuesView.joined() {
            label.removeFromSuperview()
        }
        self.valuesView = []
        guard self.configure.labelConfigure.count == self.configure.points.count else {
            return
        }
        for labelConfigures in self.configure.labelConfigure {
            var result: [DisplayLabel] = []
            for labelConfigure in labelConfigures {
                let label = DisplayLabel(configure: labelConfigure)
                self.addSubview(label)
                result.append(label)
            }
            self.valuesView.append(result)
        }
    }
    
    private func updateValueViewsDynamicConstraints() {
        for (rowIndex, labels) in self.valuesView.enumerated() {
            let labelWidth = self.bounds.width / CGFloat(labels.count + 1)
            let labelHeight = self.bounds.height / 10
            let space = labelHeight / 3
            
            guard labels.count == self.configure.points[rowIndex].count else {
                fatalError("框架内部数据处理错误，不给予拯救")
            }
            
            for (index, label) in labels.enumerated() {
                let realPoint = self.convertScalePointToRealPointWtihLimit(for: self.configure.points[rowIndex][index], rect: self.bounds)
                let center = CGPoint(x: realPoint.x, y: realPoint.y - space - labelHeight / 2)
                label.snp.updateConstraints{
                    make in
                    make.center.equalTo(center)
                    make.width.equalTo(labelWidth)
                    make.height.equalTo(labelHeight)
                }
            }
        }
    }
    
    
    
    private func convertScalePointToRealPointWtihLimit(for point: CGPoint, rect: CGRect) -> CGPoint {
        var realPoint = point
        if realPoint.x < 0 {
            realPoint.x = 0
        } else if realPoint.x > 1 {
            realPoint.x = 1
        }
        
        if realPoint.y < 0 {
            realPoint.y = 0
        } else if realPoint.y > 1 {
            realPoint.y = 1
        }
        realPoint = CGPoint(x: rect.width * realPoint.x + rect.origin.x, y: rect.origin.y + rect.height * (1 - realPoint.y))
        return realPoint
    }
}
