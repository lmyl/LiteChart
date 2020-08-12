//
//  SquareLegend.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/6.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit

class SquareLegend: UIView {
    
    private var color: LiteChartDarkLightColor
    
    init(color: LiteChartDarkLightColor) {
        self.color = color
        super.init(frame: CGRect())
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        self.color = .init(lightUIColor: .yellow, darkUIColor: .blue)
        super.init(coder: coder)
        self.backgroundColor = .clear
    }
    
    
    override func draw(_ rect: CGRect) {
        let width = rect.width
        let height = rect.height
        let squareWidth = min(width, height)
        let context = UIGraphicsGetCurrentContext()
        context?.setShouldAntialias(true)
        context?.setAllowsAntialiasing(true)
        context?.clear(rect)
        let topLeftX = rect.origin.x + (rect.width - squareWidth) / 2
        let topLeftY = rect.origin.y + (rect.height - squareWidth) / 2
        let originPoint = CGPoint(x: topLeftX, y: topLeftY)
        let squareSize = CGSize(width: squareWidth, height: squareWidth)
        let square = CGRect(origin: originPoint, size: squareSize)
        context?.addRect(square)
        context?.setFillColor(self.color.color.cgColor)
        context?.drawPath(using: .fill)
    }
    
}
