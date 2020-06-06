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
        
        let backgroundView = FunalChart(configure: .init(funalViewConfigure: .init(models: [.init(backgroundViewConfigure: .init(color: .init(lightColor: .pink), backgroundColor: .init(lightColor: .white), topPercent: 1, bottomPercent: 0.7), contentViewConfigure: .init(contentString: "37.6", contentColor: .init(lightColor: .black))), .init(backgroundViewConfigure: .init(color: .init(lightColor: .pink), backgroundColor: .init(lightColor: .white), topPercent: 0.7, bottomPercent: 0.5), contentViewConfigure: .init(contentString: "37.6", contentColor: .init(lightColor: .black))), .init(backgroundViewConfigure: .init(color: .init(lightColor: .pink), backgroundColor: .init(lightColor: .white), topPercent: 0.5, bottomPercent: 0.3), contentViewConfigure: .init(contentString: "37.6", contentColor: .init(lightColor: .black))), .init(backgroundViewConfigure: .init(color: .init(lightColor: .pink), backgroundColor: .init(lightColor: .white), topPercent: 0.3, bottomPercent: 0), contentViewConfigure: .init(contentString: "37.6", contentColor: .init(lightColor: .black)))]), chartTitleConfigure: .init(contentString: "绿色", contentColor: .init(lightColor: .green)), legendViewsConfigure: .init(models: [.init(legendType: .square, legendConfigure: .init(color: .init(lightColor: .purple), backgroundColor: .init(lightColor: .white)), contentConfigure: .init(contentString: "绿色", contentColor: .init(lightColor: .green))), .init(legendType: .square, legendConfigure: .init(color: .init(lightColor: .purple), backgroundColor: .init(lightColor: .white)), contentConfigure: .init(contentString: "绿色", contentColor: .init(lightColor: .green))), .init(legendType: .square, legendConfigure: .init(color: .init(lightColor: .purple), backgroundColor: .init(lightColor: .white)), contentConfigure: .init(contentString: "绿色", contentColor: .init(lightColor: .green))), .init(legendType: .square, legendConfigure: .init(color: .init(lightColor: .purple), backgroundColor: .init(lightColor: .white)), contentConfigure: .init(contentString: "绿色", contentColor: .init(lightColor: .green)))])))
        self.view.addSubview(backgroundView)
        
        backgroundView.snp.makeConstraints{
            make in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(500)
        }
        
    }


}

