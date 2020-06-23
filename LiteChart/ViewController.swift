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
        
        let configure = RadarBackgroundViewConfigure(coupleTitlesConfigure: [.init(contentString: "111", contentColor: .init(lightColor: .black)), .init(contentString: "222", contentColor: .init(lightColor: .black)), .init(contentString: "333", contentColor: .init(lightColor: .black))], radarLineColor: .init(lightColor: .Gray), radarLightColor: .init(lightColor: .white), radarUnlightColor: .init(lightColor: .lightGray), radarCount: 5, pointCount: 3)
        let backgroundView = RadarBackgroundView(configure: configure)
        
        self.view.addSubview(backgroundView)
        backgroundView.snp.updateConstraints{
            make in
            make.width.equalTo(300)
            make.center.equalToSuperview()
            make.height.equalTo(300)
        }
        
    }


}

