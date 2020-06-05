//
//  DisplayLabel.swift
//  
//
//  Created by 刘洋 on 2020/6/5.
//

import UIKit

class DisplayLabel: UILabel {
    init(configure: DisplayLabelConfigure) {
        super.init(frame: CGRect())
        self.text = configure.contentString
        self.textColor = configure.contentColor.color
        self.textAlignment = .center
        self.adjustsFontSizeToFitWidth = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
