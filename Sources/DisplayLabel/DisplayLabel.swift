//
//  DisplayLabel.swift
//  
//
//  Created by 刘洋 on 2020/6/5.
//

import UIKit

class DisplayLabel: UILabel {
    
    let configure: DisplayLabelConfigure
    
    init(configure: DisplayLabelConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
        self.text = configure.contentString
        self.textColor = configure.contentColor.color
        self.textAlignment = configure.textAlignment
        self.adjustsFontSizeToFitWidth = true
        self.baselineAdjustment = .alignCenters
        self.numberOfLines = 1
        self.font = UIFont.systemFont(ofSize: 17)
    }
    
    required init?(coder: NSCoder) {
        self.configure = DisplayLabelConfigure()
        super.init(coder: coder)
    }
}

extension DisplayLabel {
    func computeSuitableFont(for size: CGSize) -> UIFont {
        var newFont = self.font!
        var fontSize = newFont.pointSize
        let nsstring = self.configure.contentString as NSString
        var rect = nsstring.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : newFont], context: nil)
        while rect.height > size.height || rect.width > size.width {
            if fontSize <= 0.5 {
                return UIFont.systemFont(ofSize: 0.1)
            }
            fontSize -= 0.5
            newFont = UIFont.systemFont(ofSize: fontSize)
            rect = nsstring.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : newFont], context: nil)
        }
        return newFont
    }
}

