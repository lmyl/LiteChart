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
//        let datas: [(LiteChartDarkLightColor, [(CGFloat, CGPoint)])] = [(LiteChartDarkLightColor.init(lightUIColor: .green), [(1.0, CGPoint(x: 20, y: 20)), (5, CGPoint(x: 10, y: 20)), (10, CGPoint(x: 10, y: 17)), (20, CGPoint(x: 2, y: 10)), (17, CGPoint(x: -20, y: 20)), (27, CGPoint(x: -20, y: -20))])]
//        var configure = LiteChartViewParameters(inputDatas: .bubble(inputDatas: datas))
//        var configure = LiteChartViewParameters(inputDatas: .radar(inputDatas: [(LiteChartDarkLightColor.init(lightUIColor: .green), [0.20, 0.30, 0.40 ,0.50])]))
        configure.inputLegendTitles = ["2018"]
        configure.titleString = "年度绩效总结"
        configure.isShowLegendTitles = true
        configure.displayDataMode = .original
        configure.isShowValueDividingLine = true
        configure.isShowCoupleDividingLine = true
        configure.axisColor = .init(lightUIColor: .red)
        configure.radarLayerCount = 5
        configure.radarCoupleTitles = ["电", "水", "煤气", "天然气"]
        configure.isShowRadarCoupleTitles = true
        
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
        if let display = self.displayView {
            if self.showType == 1 {
                display.snp.remakeConstraints{
                    make in
                    make.width.equalToSuperview().multipliedBy(0.3)
                    make.height.equalTo(100)
                    make.center.equalToSuperview()
                }
                self.showType = 2
            } else {
                display.snp.remakeConstraints{
                    make in
                    make.width.equalToSuperview()
                    make.height.equalTo(300)
                    make.center.equalToSuperview()
                }
                self.showType = 1
            }
        }
    }

}

