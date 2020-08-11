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
        
        var configure = LiteChartViewParameters(inputDatas: .line(inputDatas: [(LiteChartDarkLightColor.init(lightUIColor: .blue), LineStyle.dottedCubicBezierCurve, Legend.circle, [20, 30, 40, 50, 60]), (LiteChartDarkLightColor.init(lightUIColor: .green), LineStyle.solidCubicBezierCurve, Legend.hexagon, [1, 55, 123, 20, 70]), (LiteChartDarkLightColor.init(lightUIColor: .systemPink), LineStyle.dottedPolyline, Legend.triangle, [5.7, 67.89, 99.99, 155.55, 60.66])], coupleTitle: ["煤气", "天然气", "自来水", "电", "太阳能"]))
        configure.inputLegendTitles = ["2018", "2019", "2020"]
        configure.titleString = "年度绩效总结"
        configure.isShowLegendTitles = true
        configure.displayDataMode = .original
        configure.isShowValueDividingLine = true
        configure.isShowCoupleDividingLine = true
        
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

