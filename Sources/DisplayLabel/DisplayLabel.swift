//
//  DisplayLabel.swift
//  
//
//  Created by 刘洋 on 2020/6/5.
//

import UIKit

class DisplayLabel: UIView {
    
    let configure: DisplayLabelConfigure
        
    init(configure: DisplayLabelConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        self.configure = DisplayLabelConfigure()
        super.init(coder: coder)
    }
    
    override func draw(_ rect: CGRect) {
        
        guard rect.size != .zero else {
            return
        }
        
        let adjustFontAndSize = self.computeSuitableFont(for: rect.size)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = self.configure.textAlignment
        var textAttributs: [NSAttributedString.Key : Any] = [:]
        textAttributs[.font] = adjustFontAndSize.0
        textAttributs[.foregroundColor] = self.configure.contentColor.color
        textAttributs[.paragraphStyle] = paragraphStyle
        
        let stringRect = CGRect(x: rect.origin.x, y: rect.origin.y + (rect.height - adjustFontAndSize.1.height) / 2, width: rect.width, height: adjustFontAndSize.1.height)
        
        let nsString = self.configure.contentString as NSString
        nsString.draw(in: stringRect, withAttributes: textAttributs)
        
    }
}

extension DisplayLabel {
    func computeSuitableFont(for size: CGSize) -> (UIFont, CGSize) {
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

