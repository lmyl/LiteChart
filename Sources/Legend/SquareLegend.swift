//
//  SquareLegend.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/6.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit

class SquareLegend: UIView {
    
    var configure: LegendConfigure
    
    init(configure: LegendConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
    }
    
    required init?(coder: NSCoder) {
        self.configure = LegendConfigure()
        super.init(coder: coder)
    }
    
    
    override func draw(_ rect: CGRect) {
        let width = rect.width
        let height = rect.height
        let squareWidth = min(width, height)
        let context = UIGraphicsGetCurrentContext()
        context?.setShouldAntialias(true)
        context?.setAllowsAntialiasing(true)
        context?.setFillColor(self.configure.backgroundColor.color.cgColor)
        context?.fill(rect)
        let topLeftX = rect.origin.x + (rect.width - squareWidth) / 2
        let topLeftY = rect.origin.y + (rect.height - squareWidth) / 2
        let originPoint = CGPoint(x: topLeftX, y: topLeftY)
        let squareSize = CGSize(width: squareWidth, height: squareWidth)
        let square = CGRect(origin: originPoint, size: squareSize)
        context?.addRect(square)
        context?.setFillColor(self.configure.color.color.cgColor)
        context?.drawPath(using: .fill)
    }
    
}
