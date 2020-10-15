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
    
    var displayView: UIView?
    var showType = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        var barInterface = LiteChartBarChartInterface(inputDatas: [(.init(lightUIColor: .green), [20, 30, 40, 50]), (.init(lightUIColor: .red), [20, 30, 40, 20]), (.init(lightUIColor: .yellow), [20, 30, 100, 20])], coupleTitle: ["W", "E", "G", "A"])
        barInterface.inputLegendTitles = ["2019", "2020", "2021"]
        barInterface.underlayerColor = .init(lightColor: .blue)
        barInterface.unitTextColor = .init(lightColor: .gold)
        barInterface.isShowValueUnitString = true
        barInterface.isShowCoupleUnitString = true
        barInterface.isShowValueDividingLine = true
        barInterface.isShowCoupleDividingLine = false
        barInterface.valueUnitString = "kg/L"
        barInterface.coupleUnitString = "月/年"
        barInterface.direction = .bottomToTop

        var pieInterface = LiteChartPieChartInterface(inputDatas: [(90, .init(lightUIColor: .red)), (30, .init(lightUIColor: .yellow)), (30, .init(lightUIColor: .green))])
        pieInterface.inputLegendTitles = ["2019", "2020", "2021"]
        pieInterface.displayDataMode = .original
 
        
        var funnelInterface = LiteChartFunnelChartInterface(inputDatas: [(100, .init(lightUIColor: .red)), (90, .init(lightUIColor: .blue)), (80, .init(lightUIColor: .purple)), (70, .init(lightUIColor: .blue)),(60, .init(lightUIColor: .blue)),(50, .init(lightUIColor: .blue)),(50, .init(lightUIColor: .blue)),(50, .init(lightUIColor: .blue)),(50, .init(lightUIColor: .blue)),(50, .init(lightUIColor: .blue))])
        funnelInterface.inputLegendTitles = ["2019", "2020", "2021", "2022","2019", "2020", "2021", "2022", "2023", "2024"]
        funnelInterface.displayDataMode = .mix
        
        var lineInterface = LiteChartLineChartInterface(inputDatas: [(LiteChartDarkLightColor.init(lightUIColor: .blue), LineStyle.dottedCubicBezierCurve, Legend.circle, [-20, 30, 40, 50, 60]), (LiteChartDarkLightColor.init(lightUIColor: .green), LineStyle.solidCubicBezierCurve, Legend.square, [1, 55, 123, 20, 70]), (LiteChartDarkLightColor.init(lightUIColor: .systemPink), LineStyle.dottedPolyline, Legend.triangle, [-5.7, 67.89, 99.99, 155, 60.6])], coupleTitle: ["煤气", "天然气", "自来水", "电", "太阳能"])
        lineInterface.inputLegendTitles = ["2019", "2020", "2021"]
        lineInterface.underlayerColor = .init(lightColor: .blue)
        lineInterface.unitTextColor = .init(lightColor: .gold)
        lineInterface.valueUnitString = "kg/L"
        lineInterface.coupleUnitString = "月/年"
        lineInterface.isShowValueUnitString = true
        lineInterface.isShowCoupleUnitString = true
        lineInterface.isShowValueDividingLine = true
        lineInterface.isShowCoupleDividingLine = true
        lineInterface.dividingValueLineStyle = .segment
        lineInterface.dividingCoupleLineStyle = .segment
        
        let datas: [(LiteChartDarkLightColor, Legend, [CGPoint])] = [(.init(lightUIColor: .red), .circle, [CGPoint(x: 10, y: 17), CGPoint(x: 2, y: 10), CGPoint(x: -20, y: 20)]), (.init(lightUIColor: .orange), .triangle, [CGPoint(x: -10, y: 17), CGPoint(x: 2, y: -10), CGPoint(x: -20, y: -20)]), (.init(lightUIColor: .blue), .square, [CGPoint(x: -10, y: -17), CGPoint(x: -2, y: -10), CGPoint(x: -25, y: -10)])]
        var scatterInterface = LiteChartScatterChartInterface(inputDatas: datas)
        scatterInterface.isShowValueDividingLine = true
        scatterInterface.isShowCoupleDividingLine = true
        scatterInterface.dividingValueLineStyle = .segment
        scatterInterface.dividingCoupleLineStyle = .segment
        scatterInterface.inputLegendTitles = ["2019", "2020", "2021"]
        scatterInterface.isShowValueUnitString = true
        scatterInterface.isShowCoupleUnitString = true
        scatterInterface.valueUnitString = "kg/L"
        scatterInterface.coupleUnitString = "月/年"
        scatterInterface.underlayerColor = .init(lightColor: .blue)
        scatterInterface.unitTextColor = .init(lightColor: .gold)
        
        let bubbleDatas: [(LiteChartDarkLightColor, [(CGFloat, CGPoint)])] = [(LiteChartDarkLightColor.init(lightUIColor: .green), [(1.0, CGPoint(x: 20, y: 20)), (5, CGPoint(x: 10, y: 20)), (10, CGPoint(x: 10, y: 17)), (20, CGPoint(x: 2, y: 10)), (17, CGPoint(x: -20, y: 20)), (27, CGPoint(x: -20, y: -20))]), (LiteChartDarkLightColor.init(lightUIColor: .red), [(1.0, CGPoint(x: -20, y: 20)), (5, CGPoint(x: 10, y: -20)), (10, CGPoint(x: -10, y: 17)), (20, CGPoint(x: 2, y: -10)), (17, CGPoint(x: 20, y: 20)), (27, CGPoint(x: -20, y: 20))])]
        var bubbleInterface = LiteChartBubbleChartInterface(inputDatas: bubbleDatas)
        bubbleInterface.isShowValueDividingLine = true
        bubbleInterface.isShowCoupleDividingLine = true
        bubbleInterface.dividingValueLineStyle = .segment
        bubbleInterface.dividingCoupleLineStyle = .segment
        bubbleInterface.inputLegendTitles = ["2019", "2020"]
        bubbleInterface.isShowValueUnitString = true
        bubbleInterface.isShowCoupleUnitString = true
        bubbleInterface.valueUnitString = "kg/L"
        bubbleInterface.coupleUnitString = "月/年"
        bubbleInterface.underlayerColor = .init(lightColor: .blue)
        bubbleInterface.unitTextColor = .init(lightColor: .gold)
        
        
        var radarInterface = LiteChartRadarChartInterface(inputDatas: [(LiteChartDarkLightColor.init(lightUIColor: .green), [0.20, 0.20, 0.30, 0.40 ,0.50]), (LiteChartDarkLightColor.init(lightUIColor: .red), [0.30, 0.90, 0.70, 0.50 ,0.1]),(LiteChartDarkLightColor.init(lightUIColor: .yellow), [0.10, 0.60, 0.40, 0.90 ,0.5])])
        radarInterface.radarCount = 3
        radarInterface.inputLegendTitles = ["2019", "2020", "2021"]
        radarInterface.coupleTitles = ["Water", "ElectricEle", "Oil", "Gas", "Fire"]
        radarInterface.isShowingCoupleTitles = true
        radarInterface.coupleTitlesColor = .init(lightColor: .blue)
        radarInterface.radarLineColor = .init(lightColor: .orange)
        radarInterface.radarUnlightColor = .init(lightColor: .cyan)
        radarInterface.radarLightColor = .init(lightColor: .pink)

        var interface = LiteChartViewInterface(contentInterface: lineInterface)
        interface.isShowLegendTitles = true
        interface.isShowChartTitleString = true
        interface.chartTitleString = "年度费用"
        interface.chartTitleColor = .init(lightUIColor: .red)
        interface.chartTitleDisplayLocation = .top
        
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
            } else if self.showType == 2{
                display.snp.remakeConstraints{
                    make in
                    make.width.equalToSuperview().multipliedBy(0.1)
                    make.height.equalTo(30)
                    make.center.equalToSuperview()
                }
                self.showType = 3
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

