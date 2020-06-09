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
        
        var configure = LiteChartViewParameters()
        configure.inputDatas = .funal(inputDatas: [(200, .init(lightUIColor: .yellow)), (100, .init(lightUIColor: .green)), (50, .init(lightUIColor: .orange)), (25, .init(lightUIColor: .blue))])
        configure.inputLegendTitles = ["第一月", "第二月", "第三月", "第四月"]
        configure.titleString = "月份销售收入"
        configure.titleDisplayLocation = .bottom
        configure.textColor = .init(lightUIColor: .cyan)
        
        let backgroundView = try! LiteChartView(configure: configure)
        self.view.addSubview(backgroundView)
        
        backgroundView.snp.makeConstraints{
            make in
            make.center.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(300)
        }
        
        
    }


}

