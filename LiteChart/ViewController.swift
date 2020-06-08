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
        
        var configure = FunalChartParameters(inputDatas: [(100, .init(lightUIColor: .blue)), (73, .init(lightUIColor: .yellow)), (34, .init(lightUIColor: .green)), (24, .init(lightUIColor: .systemPink))])
        configure.displayDataMode = .original
        configure.titleString = "黄小卉绿了？"
        configure.inputLegendTitles = ["绿了", "稍微绿了", "有点绿了", "全绿了"]
        
        do {
            let backgroundView = try FunalChart(parameter: configure)
            self.view.addSubview(backgroundView)
            
            backgroundView.snp.makeConstraints{
                make in
                make.center.equalToSuperview()
                make.width.equalToSuperview()
                make.height.equalTo(300)
            }
        } catch {
            
        }
        
        
    }


}

