//
//  DisplayLabel.swift
//  
//
//  Created by 刘洋 on 2020/6/5.
//

import UIKit

class DisplayLabel: UIView {
    
    private let configure: DisplayLabelConfigure
        
    init(configure: DisplayLabelConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        self.configure = DisplayLabelConfigure.emptyConfigure
        super.init(coder: coder)
        self.backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        context?.clear(rect)
        var textSizeArea = rect.size
        if self.configure.textDirection == .vertical {
            context?.rotate(by: CGFloat(0 - Double.pi / 2))
            textSizeArea = CGSize(width: textSizeArea.height, height: textSizeArea.width)
        }
        
        let adjustFontAndSize = self.computeSuitableFont(for: textSizeArea)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = self.configure.textAlignment
        var textAttributs: [NSAttributedString.Key : Any] = [:]
        textAttributs[.font] = adjustFontAndSize.0
        textAttributs[.foregroundColor] = self.configure.contentColor.color
        textAttributs[.paragraphStyle] = paragraphStyle
        
        var stringRect: CGRect
        switch self.configure.textDirection {
        case .horizontal:
            stringRect = CGRect(x: rect.origin.x, y: rect.origin.y + (rect.height - adjustFontAndSize.1.height) / 2, width: rect.width, height: adjustFontAndSize.1.height)
        case .vertical:
            let textSize = adjustFontAndSize.1
            stringRect = CGRect(x: 0 - rect.height, y: (rect.width - textSize.height) / 2, width: rect.height, height: textSize.height)
        }
        let nsString = self.configure.contentString as NSString
        nsString.draw(in: stringRect, withAttributes: textAttributs)
        
        context?.restoreGState()
        
    }
}

extension DisplayLabel {
    private func computeSuitableFont(for size: CGSize) -> (UIFont, CGSize) {
        var newFont = UIFont.systemFont(ofSize: 17)
        var fontSize = newFont.pointSize
        let nsstring = self.configure.contentString as NSString
        var rect = nsstring.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : newFont], context: nil)
        while rect.height > size.height || rect.width > size.width {
            if fontSize <= 0.5 {
                fontSize = 0.1
                rect = nsstring.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : newFont], context: nil)
                return (UIFont.systemFont(ofSize: fontSize), rect.size)
            }
            fontSize -= 0.5
            newFont = UIFont.systemFont(ofSize: fontSize)
            rect = nsstring.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : newFont], context: nil)
        }
        return (newFont, rect.size)
    }
}

