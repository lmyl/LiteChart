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
        
        var configure = LiteChartViewParameters(inputDatas: .funal(inputDatas: [(80, .init(lightUIColor: .yellow)), (40, .init(lightUIColor: .systemPink))]))
        configure.coupleTitles = ["0月", "1月", "2月", "3月", "4月", "5月"]
        configure.radarCount = 5
        configure.inputLegendTitles = ["2018", "2019"]
        configure.titleString = "年度绩效总结"
        configure.isShowCoupleTitles = true
        configure.isShowLegendTitles = true
        
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

