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
        
        var configure = LiteChartViewParameters(inputDatas: .bar(inputDatas: [(.init(lightColor: .blueViolet), [30, 40, 50, 60])], coupleTitle: ["橘子", "苹果", "香蕉", "李子"]))
        configure.isShowValueDividingLine = true
        configure.isShowCoupleDividingLine = true
        
        do {
            let backgroundView = try LiteChartView(configure: configure)
            self.view.addSubview(backgroundView)
            
            backgroundView.snp.makeConstraints{
                make in
                make.center.equalToSuperview()
                make.width.equalTo(300)
                make.height.equalTo(300)
            }
        } catch(let error) {
            print(error.localizedDescription)
        }
        
    }


}

