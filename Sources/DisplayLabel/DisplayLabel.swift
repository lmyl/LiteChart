//
//  DisplayLabel.swift
//  
//
//  Created by 刘洋 on 2020/6/5.
//

import UIKit

class DisplayLabel: UILabel {
    convenience init(frame: CGRect, contentString: String, titleColor: LiteChartDarkLightColor) {
        self.init(frame: frame)
        self.text = contentString
        self.textColor = titleColor.color
        self.textAlignment = .center
        self.adjustsFontSizeToFitWidth = true
    }
}
