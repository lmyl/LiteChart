//
//  ViewController.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/5.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        var configure = AxisViewConfigure(originPoint: CGPoint(x: 0.5, y: 0.8), axisColor: .init(lightUIColor: .green), verticalDividingPoints: [.init(dividingLineStyle: .dotted, dividingLineColor: .init(lightUIColor: .black), location: 0.3), .init(dividingLineStyle: .solid, dividingLineColor: .init(lightUIColor: .black), location: 0.6), .init(dividingLineStyle: .segment, dividingLineColor: .init(lightUIColor: .black), location: 0.1)], horizontalDividingPoints: [.init(dividingLineStyle: .dotted, dividingLineColor: .init(lightUIColor: .black), location: 0.3), .init(dividingLineStyle: .solid, dividingLineColor: .init(lightUIColor: .black), location: 0.6), .init(dividingLineStyle: .segment, dividingLineColor: .init(lightUIColor: .black), location: 0.1)], borderStyle: [.bottom], borderColor: .init(lightUIColor: .yellow))
        
        let backgroundView = AxisView(configure: configure)
        self.view.addSubview(backgroundView)
        
        backgroundView.snp.makeConstraints{
            make in
            make.center.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(300)
        }
        
        
    }


}

