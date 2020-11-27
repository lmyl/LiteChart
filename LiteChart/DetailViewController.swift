//
//  DetailViewController.swift
//  LiteChart
//
//  Created by huangxiaohui on 2020/10/26.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class DetailViewController: UIViewController {
    
    var chartKind = ChartKind.PieChart
    var displayView: LiteChartView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = self.chartKind.description
        
        switch self.chartKind {
        case .PieChart:
            var pieInterface = LiteChartPieChartInterface(inputDatas: [(90, .init(lightUIColor: UIColor(red: 2/255, green: 211/255, blue: 180/255, alpha: 1))), (60, .init(lightUIColor: UIColor(red: 0, green: 95/255, blue: 151/255, alpha: 1))), (45, .init(lightUIColor: UIColor(red: 255/255, green: 165/255, blue: 180/255, alpha: 1)))])
            pieInterface.inputLegendTitles = ["2019", "2020", "2021"]
            pieInterface.displayDataMode = .percent
            
            var interface = LiteChartViewInterface(contentInterface: pieInterface)
            interface.isShowLegendTitles = true
            interface.isShowChartTitleString = true
            interface.chartTitleString = "年度费用"
            interface.chartTitleColor = .init(lightUIColor: UIColor(sRGB3PRed: 62, green: 62, blue: 62))
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
        case .LineChart:
            var lineInterface = LiteChartLineChartInterface(inputDatas: [(LiteChartDarkLightColor.init(lightUIColor: UIColor(red: 2/255, green: 211/255, blue: 180/255, alpha: 1)), LineStyle.dottedCubicBezierCurve, Legend.circle, [-20, 30, 40, 50, 60]), (LiteChartDarkLightColor.init(lightUIColor: UIColor(red: 0, green: 95/255, blue: 151/255, alpha: 1)), LineStyle.solidCubicBezierCurve, Legend.square, [1, 55, 123, 20, 70]), (LiteChartDarkLightColor.init(lightUIColor: UIColor(sRGB3PRed: 255, green: 165, blue: 180)), LineStyle.solidCubicBezierCurve, Legend.triangle, [-5.7, 67.89, 99.99, 155, 60.6])], coupleTitle: ["Swift", "Python", "Java", "Ruby", "PHP"])
            lineInterface.inputLegendTitles = ["2019", "2020", "2021"]
            lineInterface.underlayerColor = .init(lightColor: .dimGray)
            lineInterface.unitTextColor = .init(lightColor: .dimGray)
            lineInterface.valueUnitString = "usage"
            lineInterface.coupleUnitString = "language"
            lineInterface.isShowValueUnitString = true
            lineInterface.isShowCoupleUnitString = true
            lineInterface.isShowValueDividingLine = true
            lineInterface.isShowCoupleDividingLine = true
            lineInterface.dividingValueLineStyle = .dotted
            lineInterface.dividingCoupleLineStyle = .solid
            lineInterface.displayDataMode = .original
            
            var interface = LiteChartViewInterface(contentInterface: lineInterface)
            interface.isShowChartTitleString = true
            interface.chartTitleString = "example"
            interface.isShowLegendTitles = true
            interface.chartTitleColor = .init(lightUIColor: UIColor(sRGB3PRed: 62, green: 62, blue: 62))
            let backgroundView = try! LiteChartView(interface: interface)
            self.view.addSubview(backgroundView)
            self.displayView = backgroundView
            backgroundView.snp.updateConstraints{
                make in
                make.width.equalToSuperview()
                make.center.equalToSuperview()
                make.height.equalTo(300)
            }
        case .RadarChart:
            var radarInterface = LiteChartRadarChartInterface(inputDatas: [(LiteChartDarkLightColor.init(lightUIColor: UIColor(sRGB3PRed: 2, green: 211, blue: 180)), [0.20, 0.20, 0.30, 0.40 ,0.50]), (LiteChartDarkLightColor.init(lightUIColor: UIColor(sRGB3PRed: 0, green: 95, blue: 151)), [0.30, 0.90, 0.70, 0.50 ,0.1]),(LiteChartDarkLightColor.init(lightUIColor: UIColor(sRGB3PRed: 255, green: 165, blue: 180)), [0.10, 0.60, 0.40, 0.90 ,0.5])])
            radarInterface.radarCount = 3
            radarInterface.inputLegendTitles = ["2019", "2020", "2021"]
            radarInterface.coupleTitles = ["一月", "二月", "三月", "四月", "五月"]
            radarInterface.isShowingCoupleTitles = true
            radarInterface.coupleTitlesColor = .init(lightUIColor: UIColor(sRGB3PRed: 62, green: 62, blue: 62))
            radarInterface.radarLineColor = .init(lightUIColor: UIColor(sRGB3PRed: 165, green: 165, blue: 165))
            radarInterface.radarUnlightColor = .init(lightColor: .lightGray)
            radarInterface.radarLightColor = .init(lightColor: .white)
            var interface = LiteChartViewInterface(contentInterface: radarInterface)
            interface.isShowChartTitleString = true
            interface.chartTitleString = "资源占比"
            interface.chartTitleColor = .init(lightUIColor: UIColor(sRGB3PRed: 62, green: 62, blue: 62))
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
           
        case .BubbleChart:
            let bubbleDatas: [(LiteChartDarkLightColor, [(CGFloat, CGPoint)])] = [(LiteChartDarkLightColor.init(lightUIColor: UIColor(red: 2/255, green: 211/255, blue: 180/255, alpha: 1)), [(1.0, CGPoint(x: 20, y: 20)), (5, CGPoint(x: 10, y: 20)), (10, CGPoint(x: 10, y: 17)), (20, CGPoint(x: 2, y: 10)), (17, CGPoint(x: -20, y: 20)), (27, CGPoint(x: -20, y: -20))]), (LiteChartDarkLightColor.init(lightUIColor: UIColor(red: 0, green: 95/255, blue: 151/255, alpha: 1)), [(1.0, CGPoint(x: -20, y: 20)), (5, CGPoint(x: 10, y: -20)), (10, CGPoint(x: -10, y: 17)), (20, CGPoint(x: 2, y: -10)), (17, CGPoint(x: 20, y: 20)), (27, CGPoint(x: -20, y: 20))])]
            var bubbleInterface = LiteChartBubbleChartInterface(inputDatas: bubbleDatas)
            bubbleInterface.isShowValueDividingLine = true
            bubbleInterface.isShowCoupleDividingLine = true
            bubbleInterface.dividingValueLineStyle = .segment
            bubbleInterface.dividingCoupleLineStyle = .segment
            bubbleInterface.inputLegendTitles = ["2019", "2020"]
            bubbleInterface.isShowValueUnitString = false
            bubbleInterface.isShowCoupleUnitString = false
            bubbleInterface.valueUnitString = "kg/L"
            bubbleInterface.coupleUnitString = "月/年"
            bubbleInterface.underlayerColor = .init(lightUIColor: UIColor(sRGB3PRed: 165, green: 165, blue: 165))
            bubbleInterface.unitTextColor = .init(lightColor: .dimGray)
            var interface = LiteChartViewInterface(contentInterface: bubbleInterface)
            interface.isShowChartTitleString = true
            interface.chartTitleString = "年产量"
            interface.chartTitleColor = .init(lightUIColor: UIColor(sRGB3PRed: 62, green: 62, blue: 62))
            let backgroundView = try! LiteChartView(interface: interface)
            self.view.addSubview(backgroundView)
            self.displayView = backgroundView
            backgroundView.snp.updateConstraints{
                make in
                make.width.equalToSuperview()
                make.center.equalToSuperview()
                make.height.equalTo(300)
            }

        case .ScatterPlotChart:
            let datas: [(LiteChartDarkLightColor, Legend, [CGPoint])] = [(.init(lightUIColor: UIColor(sRGB3PRed: 255, green: 165, blue: 180)), .circle, [CGPoint(x: 10, y: 17), CGPoint(x: 2, y: 10), CGPoint(x: -20, y: 20)]), (.init(lightUIColor: UIColor(sRGB3PRed: 2, green: 211, blue: 180)), .triangle, [CGPoint(x: -10, y: 17), CGPoint(x: 2, y: -10), CGPoint(x: -20, y: -20)]), (.init(lightUIColor: UIColor(sRGB3PRed: 0, green: 95, blue: 151)), .square, [CGPoint(x: -10, y: -17), CGPoint(x: -2, y: -10), CGPoint(x: -25, y: -10)])]
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
            scatterInterface.underlayerColor = .init(lightColor: .dimGray)
            scatterInterface.unitTextColor = .init(lightUIColor: UIColor(sRGB3PRed: 165, green: 165, blue: 165))
            let interface = LiteChartViewInterface(contentInterface: scatterInterface)
            let backgroundView = try! LiteChartView(interface: interface)
            self.view.addSubview(backgroundView)
            self.displayView = backgroundView
            backgroundView.snp.updateConstraints{
                make in
                make.width.equalToSuperview()
                make.center.equalToSuperview()
                make.height.equalTo(300)
            }
            
        case .BarChart:
            var barInterface = LiteChartBarChartInterface(inputDatas: [(.init(lightUIColor: UIColor(sRGB3PRed: 255, green: 165, blue: 180)), [20, 30, 40, 50]), (.init(lightUIColor: UIColor(sRGB3PRed: 2, green: 211, blue: 180)), [20, 30, 40, 20]), (.init(lightUIColor: UIColor(sRGB3PRed: 0, green: 95, blue: 151)), [20, 30, 100, 20])], coupleTitle: ["W", "E", "G", "A"])
            barInterface.inputLegendTitles = ["2019", "2020", "2021"]
            barInterface.underlayerColor = .init(lightUIColor: UIColor(sRGB3PRed: 165, green: 165, blue: 165))
            barInterface.unitTextColor = .init(lightColor: .dimGray, darkColor: .dimGray)
            barInterface.isShowValueUnitString = true
            barInterface.isShowCoupleUnitString = true
            barInterface.isShowValueDividingLine = true
            barInterface.isShowCoupleDividingLine = false
            barInterface.valueUnitString = "kg/L"
            barInterface.coupleUnitString = "月/年"
            barInterface.direction = .bottomToTop
            barInterface.borderStyle = .fullySurrounded
            var interface = LiteChartViewInterface(contentInterface: barInterface)
            interface.isShowChartTitleString = true
            interface.chartTitleColor = .init(lightColor: .dimGray)
            interface.chartTitleString = "年度报表"
            interface.chartTitleColor = .init(lightUIColor: UIColor(sRGB3PRed: 62, green: 62, blue: 62))
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
            
        case .FunnelChart:
            var funnelInterface = LiteChartFunnelChartInterface(inputDatas: [(100, .init(lightUIColor: UIColor(sRGB3PRed: 255, green: 165, blue: 180))), (80, .init(lightUIColor: UIColor(sRGB3PRed: 2, green: 211, blue: 180))), (60, .init(lightUIColor: UIColor(sRGB3PRed: 0, green: 95, blue: 151))), (40, .init(lightUIColor: UIColor(sRGB3PRed: 255, green: 165, blue: 180))),(20, .init(lightUIColor: UIColor(sRGB3PRed: 2, green: 211, blue: 180)))])
            funnelInterface.inputLegendTitles = ["2019", "2020", "2021", "2022","2019"]
            funnelInterface.displayDataMode = .mix
            funnelInterface.valueTextColor = .init(lightColor: .white)
            var interface = LiteChartViewInterface(contentInterface: funnelInterface)
            interface.isShowChartTitleString = true
            interface.chartTitleString = "收入逐年减少"
            interface.chartTitleColor = .init(lightUIColor: UIColor(sRGB3PRed: 62, green: 62, blue: 62))
            let backgroundView = try! LiteChartView(interface: interface)
            self.view.addSubview(backgroundView)
            self.displayView = backgroundView
            backgroundView.snp.updateConstraints{
                make in
                make.width.equalToSuperview()
                make.center.equalToSuperview()
                make.height.equalTo(300)
            }
        }
       
        // 动画开始
        let animationSatrtButton = UIButton()
        self.view.addSubview(animationSatrtButton)
        animationSatrtButton.snp.updateConstraints{
            make in
            make.width.equalTo(self.view.frame.width / 4)
            make.height.equalTo(50)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        animationSatrtButton.addTarget(self, action: #selector(animation), for: .touchUpInside)
        animationSatrtButton.setTitle("开始动画", for: .normal)
        animationSatrtButton.backgroundColor = .lightGray
        
        // 动画暂停
        let animationPauseButton = UIButton()
        self.view.addSubview(animationPauseButton)
        animationPauseButton.snp.updateConstraints{
            make in
            make.width.equalTo(self.view.frame.width / 4)
            make.height.equalTo(50)
            make.leading.equalTo(animationSatrtButton.snp.trailing)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        animationPauseButton.addTarget(self, action: #selector(pauseAnimation), for: .touchUpInside)
        animationPauseButton.setTitle("暂停动画", for: .normal)
        animationPauseButton.backgroundColor = .systemPink
        
        // 动画继续
        let animationCountinueButton = UIButton()
        self.view.addSubview(animationCountinueButton)
        animationCountinueButton.snp.updateConstraints{
            make in
            make.width.equalTo(self.view.frame.width / 4)
            make.height.equalTo(50)
            make.leading.equalTo(animationPauseButton.snp.trailing)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        animationCountinueButton.addTarget(self, action: #selector(continueAnimation), for: .touchUpInside)
        animationCountinueButton.setTitle("继续动画", for: .normal)
        animationCountinueButton.backgroundColor = .lightGray
        
        // 动画结束
        let animationStopButton = UIButton()
        self.view.addSubview(animationStopButton)
        animationStopButton.snp.updateConstraints{
            make in
            make.width.equalTo(self.view.frame.width / 4)
            make.height.equalTo(50)
            make.leading.equalTo(animationCountinueButton.snp.trailing)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        animationStopButton.addTarget(self, action: #selector(stopAnimation), for: .touchUpInside)
        animationStopButton.setTitle("结束动画", for: .normal)
        animationStopButton.backgroundColor = .systemPink
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.animation()
    }
    
    @objc func animation() {
        let interface = LiteChartAnimationInterface(animationType: .base(duration: 4), delay: 0, fillModel: .both, animationTimingFunction: .init(name: .easeInEaseOut))
        self.displayView?.startAnimation(animation: interface)
    }
    
    @objc func stopAnimation() {
        self.displayView?.stopAnimation()
    }
    
    @objc func pauseAnimation() {
        self.displayView?.pauseAnimation()
    }
    
    @objc func continueAnimation() {
        self.displayView?.continueAnimation()
    }


}
