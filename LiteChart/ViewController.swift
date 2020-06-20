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
        
        var configure = LiteChartViewParameters(inputDatas: .bubble(inputDatas: [(LiteChartDarkLightColor(lightUIColor: .red), [(1, CGPoint(x: 1, y: 1))])]))
        
        configure.isShowCoupleDividingLine = true
        configure.isShowValueDividingLine = true
//        configure.inputLegendTitles = ["2018", "2019"]
        configure.valueUnitString = "温度差"
        configure.coupleUnitString = "月份"
        configure.axisColor = .init(lightColor: .orange)
        
        let backgroundView = try! LiteChartView(configure: configure)
        
        self.view.addSubview(backgroundView)
        backgroundView.snp.updateConstraints{
            make in
            make.width.equalToSuperview()
            make.center.equalToSuperview()
            make.height.equalTo(300)
        }
        
    }


}

