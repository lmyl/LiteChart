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
        
//        var configure = LiteChartViewParameters(inputDatas: .pie(inputDatas: [(90, .init(lightUIColor: .red)), (30, .init(lightUIColor: .yellow)), (30, .init(lightUIColor: .green))]))
//        var configure = LiteChartViewParameters(inputDatas: .bar(inputDatas: [(.init(lightUIColor: .green), [20, 30, 40, 50]), (.init(lightUIColor: .red), [20, 30, 40, 20]), (.init(lightUIColor: .yellow), [20, 30, 100, 20])], coupleTitle: ["Water", "Electoric", "Gas", "Apple"]))
//        var configure = LiteChartViewParameters(inputDatas: .line(inputDatas: [(LiteChartDarkLightColor.init(lightUIColor: .blue), LineStyle.dottedCubicBezierCurve, Legend.circle, [-20, 30, 40, 50, 60]), (LiteChartDarkLightColor.init(lightUIColor: .green), LineStyle.solidCubicBezierCurve, Legend.square, [1, 55, 123, 20, 70]), (LiteChartDarkLightColor.init(lightUIColor: .systemPink), LineStyle.dottedPolyline, Legend.triangle, [-5.7, 67.89, 99.99, 155, 60.6])], coupleTitle: ["煤气", "天然气", "自来水", "电", "太阳能"]))
//        let datas: [(LiteChartDarkLightColor, [(CGFloat, CGPoint)])] = [(LiteChartDarkLightColor.init(lightUIColor: .green), [(1.0, CGPoint(x: 20, y: 20)), (5, CGPoint(x: 10, y: 20)), (10, CGPoint(x: 10, y: 17)), (20, CGPoint(x: 2, y: 10)), (17, CGPoint(x: -20, y: 20)), (27, CGPoint(x: -20, y: -20))]), (LiteChartDarkLightColor.init(lightUIColor: .yellow), [(1.0, CGPoint(x: -20, y: 20)), (5, CGPoint(x: 10, y: -20)), (10, CGPoint(x: -10, y: 17)), (20, CGPoint(x: 2, y: -10)), (17, CGPoint(x: 20, y: 20)), (27, CGPoint(x: -20, y: 20))])]
//        let datas: [(LiteChartDarkLightColor, Legend, [CGPoint])] = [(.init(lightUIColor: .red), .circle, [CGPoint(x: 10, y: 17), CGPoint(x: 2, y: 10), CGPoint(x: -20, y: 20)]), (.init(lightUIColor: .orange), .triangle, [CGPoint(x: -10, y: 17), CGPoint(x: 2, y: -10), CGPoint(x: -20, y: -20)]), (.init(lightUIColor: .blue), .square, [CGPoint(x: -10, y: -17), CGPoint(x: -2, y: -10), CGPoint(x: -25, y: -10)])]
//        var configure = LiteChartViewParameters(inputDatas: .scatter(inputDatas: datas))
//        var configure = LiteChartViewParameters(inputDatas: .bubble(inputDatas: datas))
//        var configure = LiteChartViewParameters(inputDatas: .radar(inputDatas: [(LiteChartDarkLightColor.init(lightUIColor: .green), [0.20, 0.20, 0.30, 0.40 ,0.50]), (LiteChartDarkLightColor.init(lightUIColor: .red), [0.30, 0.20, 0.30, 0.50 ,0.9])]))
//        var configure = LiteChartViewParameters(inputDatas: .funal(inputDatas: [(100, .init(lightUIColor: .red)), (50, .init(lightUIColor: .purple))]))
//        configure.inputLegendTitles = ["2018", "2019", "2020"]
//        configure.titleString = "年度绩效总结"
//        configure.isShowLegendTitles = true
//        configure.displayDataMode = .original
//        configure.isShowValueDividingLine = true
//        configure.isShowCoupleDividingLine = true
//        configure.borderStyle = .halfSurrounded
//        configure.barDirection = .bottomToTop
//        configure.displayDataMode = .original
//        configure.axisColor = .init(lightUIColor: .yellow)
//        configure.radarLayerCount = 5
//        configure.radarCoupleTitles = ["电", "水", "煤气", "天然气", "Apple"]
//        configure.isShowRadarCoupleTitles = true
//        configure.isShowAxis = false
       
        var barInterface = LiteChartBarChartInterface(inputDatas: [(.init(lightUIColor: .green), [20, 30, 40, 50]), (.init(lightUIColor: .red), [20, 30, 40, 20]), (.init(lightUIColor: .yellow), [20, 30, 100, 20])], coupleTitle: ["Water", "Electoric", "Gas", "Apple"])
        barInterface.inputLegendTitles = ["2019", "2020", "2021"]
        barInterface.underlayerColor = .init(lightColor: .blue)
        barInterface.unitTextColor = .init(lightColor: .gold)
        barInterface.isShowValueUnitString = true
        barInterface.isShowCoupleUnitString = true
        barInterface.valueUnitString = "kg/L"
        barInterface.coupleUnitString = "月/年"
        barInterface.direction = .leftToRight
 
        /*
        var pieInterface = LiteChartPieChartInterface(inputDatas: [(90, .init(lightUIColor: .red)), (30, .init(lightUIColor: .yellow)), (30, .init(lightUIColor: .green))])
        pieInterface.inputLegendTitles = ["2019", "2020", "2021"]
        pieInterface.displayDataMode = .original
 */
        /*
        var funnelInterface = LiteChartFunnelChartInterface(inputDatas: [(100, .init(lightUIColor: .red)), (50, .init(lightUIColor: .purple)), (20, .init(lightUIColor: .blue))])
        funnelInterface.inputLegendTitles = ["2019", "2020", "2021"]*/
        var interface = LiteChartViewInterface(contentInterface: barInterface)
        interface.isShowLegendTitles = true
        interface.isShowChartTitleString = true
        interface.chartTitleString = "年度费用"
        interface.chartTitleColor = .init(lightUIColor: .red)
        let backgroundView = try! LiteChartView(interface: interface)
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
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading)
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

