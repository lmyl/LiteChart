//
//  RadarBackgroundView.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/22.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit

class RadarBackgroundView: UIView {
    let configure: RadarBackgroundViewConfigure
    
    var coupleTitles: [DisplayLabel] = []
    
    init(configure: RadarBackgroundViewConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
    }
    
    required init?(coder: NSCoder) {
        self.configure = RadarBackgroundViewConfigure()
        super.init(coder: coder)
    }
    
    private var coupleTitleWidth: CGFloat {
        let width = self.bounds.width / 10
        return min(width, 40)
    }
    
    private var coupleTitleHeight: CGFloat {
        let height = self.bounds.height / 20
        return min(height, 20)
    }
    
    private func insertCoupleTitle() {
        for label in self.configure.coupleTitlesConfigure {
            let title = DisplayLabel(configure: label)
            self.addSubview(title)
            self.coupleTitles.append(title)
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
    }
    
}
