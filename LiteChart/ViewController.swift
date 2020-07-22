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
    
    var displayView: LiteChartView?
    var showType = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        var configure = LiteChartViewParameters(inputDatas: .pie(inputDatas: [(80, .init(lightUIColor: .yellow)), (40, .init(lightUIColor: .systemPink))]))
        configure.coupleTitles = ["0月", "1月", "2月", "3月", "4月", "5月"]
        configure.radarCount = 5
        configure.inputLegendTitles = ["2018", "2019"]
        configure.titleString = "年度绩效总结"
        configure.isShowCoupleTitles = true
        configure.isShowLegendTitles = true
        configure.displayDataMode = .percent
        
        let backgroundView = try! LiteChartView(configure: configure)
        self.view.addSubview(backgroundView)
        self.displayView = backgroundView
        backgroundView.snp.updateConstraints{
            make in
            make.width.equalToSuperview()
            make.center.equalToSuperview()
            make.height.equalTo(300)
        }
        
        let button = UIButton()
        self.view.addSubview(button)
        button.snp.updateConstraints{
            make in
            make.width.equalTo(100)
            make.height.equalTo(50)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        }
        button.addTarget(self, action: #selector(action), for: .touchUpInside)
        button.backgroundColor = .yellow
    }

    @objc func action() {
        var configure: LiteChartViewParameters
        if self.showType == 1 {
            self.showType = 0
            configure = LiteChartViewParameters(inputDatas: .funal(inputDatas: [(80, .init(lightUIColor: .yellow)), (40, .init(lightUIColor: .systemPink))]))
        } else {
            self.showType = 1
            configure = LiteChartViewParameters(inputDatas: .pie(inputDatas: [(80, .init(lightUIColor: .yellow)), (40, .init(lightUIColor: .systemPink))]))
        }
        configure.coupleTitles = ["0月", "1月", "2月", "3月", "4月", "5月"]
        configure.radarCount = 5
        configure.inputLegendTitles = ["2018", "2019"]
        configure.titleString = "年度绩效总结"
        configure.isShowCoupleTitles = true
        configure.isShowLegendTitles = true
        configure.displayDataMode = .percent
        
        let backgroundView = try! LiteChartView(configure: configure)
        if let display = self.displayView {
            display.removeFromSuperview()
        }
        self.view.addSubview(backgroundView)
        self.displayView = backgroundView
        backgroundView.snp.updateConstraints{
            make in
            make.width.equalToSuperview()
            make.center.equalToSuperview()
            make.height.equalTo(300)
        }
    }

}

