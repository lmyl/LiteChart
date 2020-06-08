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
        
        var configure = PieViewsConfigure(models: [PieViewConfigure(startAngle: 0, endAngle: 30, backgroundColor: .init(lightUIColor: .yellow), displayText: "绿色", displayTextColor: .init(lightUIColor: .black)), PieViewConfigure(startAngle: 30, endAngle: 170, backgroundColor: .init(lightUIColor: .green), displayText: "绿色", displayTextColor: .init(lightUIColor: .black)), PieViewConfigure(startAngle: 170, endAngle: 360, backgroundColor: .init(lightUIColor: .orange), displayText: "绿色", displayTextColor: .init(lightUIColor: .black))])
        
        let backgroundView = PieViews(configure: configure)
        self.view.addSubview(backgroundView)
        backgroundView.backgroundColor = .red
        
        backgroundView.snp.makeConstraints{
            make in
            make.center.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(300)
        }
        
        
    }


}

