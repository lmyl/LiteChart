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
        
        let backgroundView = FunalView(configure: .init(models: [.init(backgroundViewConfigure: .init(color: .init(lightColor: .red), backgroundColor: .init(lightColor: .white), topPercent: 1, bottomPercent: 0.7), contentViewConfigure: .init(contentString: "27.5", contentColor: .init(lightColor: .hotPink))), .init(backgroundViewConfigure: .init(color: .init(lightColor: .red), backgroundColor: .init(lightColor: .white), topPercent: 0.7, bottomPercent: 0.3), contentViewConfigure: .init(contentString: "27.5", contentColor: .init(lightColor: .hotPink))), .init(backgroundViewConfigure: .init(color: .init(lightColor: .red), backgroundColor: .init(lightColor: .white), topPercent: 0.3, bottomPercent: 0.1), contentViewConfigure: .init(contentString: "27.5", contentColor: .init(lightColor: .hotPink)))]))
        self.view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints{
            make in
            make.center.equalToSuperview()
            make.width.equalTo(250)
            make.height.equalTo(200)
        }
        
    }


}

