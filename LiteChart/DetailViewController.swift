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
    var showType = 1
    
    var timer: DispatchSourceTimer?
    var timerLabel: UILabel?
    var timerCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = self.chartKind.description
        
        switch self.chartKind {
        case .PieChart:
            var pieInterface = LiteChartPieChartInterface(inputDatas: [(90, .init(lightUIColor: .red)), (60, .init(lightUIColor: .yellow)), (45, .init(lightUIColor: .green))])
            pieInterface.inputLegendTitles = ["2019", "2020", "2021"]
            pieInterface.displayDataMode = .percent
            var interface = LiteChartViewInterface(contentInterface: pieInterface)
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
        case .LineChart:
            var lineInterface = LiteChartLineChartInterface(inputDatas: [(LiteChartDarkLightColor.init(lightUIColor: .blue), LineStyle.dottedCubicBezierCurve, Legend.circle, [-20, 30, 40, 50, 60]), (LiteChartDarkLightColor.init(lightUIColor: .green), LineStyle.solidCubicBezierCurve, Legend.square, [1, 55, 123, 20, 70]), (LiteChartDarkLightColor.init(lightUIColor: .systemPink), LineStyle.solidCubicBezierCurve, Legend.triangle, [-5.7, 67.89, 99.99, 155, 60.6])], coupleTitle: ["煤气", "天然气", "自来水", "电", "太阳能"])
            lineInterface.inputLegendTitles = ["2019", "2020", "2021"]
            lineInterface.underlayerColor = .init(lightColor: .blue)
            lineInterface.unitTextColor = .init(lightColor: .gold)
            lineInterface.valueUnitString = "kg/L"
            lineInterface.coupleUnitString = "月/年"
            lineInterface.isShowValueUnitString = true
            lineInterface.isShowCoupleUnitString = true
            lineInterface.isShowValueDividingLine = true
            lineInterface.isShowCoupleDividingLine = true
            lineInterface.dividingValueLineStyle = .dotted
            lineInterface.dividingCoupleLineStyle = .solid
            lineInterface.displayDataMode = .original
            
            var interface = LiteChartViewInterface(contentInterface: lineInterface)
            interface.isShowChartTitleString = true
            interface.chartTitleString = "资源占比"
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
            var radarInterface = LiteChartRadarChartInterface(inputDatas: [(LiteChartDarkLightColor.init(lightUIColor: .green), [0.20, 0.20, 0.30, 0.40 ,0.50]), (LiteChartDarkLightColor.init(lightUIColor: .red), [0.30, 0.90, 0.70, 0.50 ,0.1]),(LiteChartDarkLightColor.init(lightUIColor: .yellow), [0.10, 0.60, 0.40, 0.90 ,0.5])])
            radarInterface.radarCount = 3
            radarInterface.inputLegendTitles = ["2019", "2020", "2021"]
            radarInterface.coupleTitles = ["Water", "ElectricEle", "Oil", "Gas", "Fire"]
            radarInterface.isShowingCoupleTitles = true
            radarInterface.coupleTitlesColor = .init(lightColor: .blue)
            radarInterface.radarLineColor = .init(lightColor: .orange)
            radarInterface.radarUnlightColor = .init(lightColor: .cyan)
            radarInterface.radarLightColor = .init(lightColor: .pink)
            var interface = LiteChartViewInterface(contentInterface: radarInterface)
            interface.isShowChartTitleString = true
            interface.chartTitleString = "资源占比"
            interface.chartTitleDisplayLocation = .bottom
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
            var interface = LiteChartViewInterface(contentInterface: bubbleInterface)
            interface.isShowChartTitleString = true
            interface.chartTitleString = "年产量"
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
            var interface = LiteChartViewInterface(contentInterface: barInterface)
            interface.isShowChartTitleString = true
            interface.chartTitleString = "年度报表"
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
            var funnelInterface = LiteChartFunnelChartInterface(inputDatas: [(100, .init(lightUIColor: .red)), (90, .init(lightUIColor: .blue)), (80, .init(lightUIColor: .purple)), (70, .init(lightUIColor: .blue)),(60, .init(lightUIColor: .blue)),(50, .init(lightUIColor: .blue)),(50, .init(lightUIColor: .blue)),(50, .init(lightUIColor: .blue)),(50, .init(lightUIColor: .blue)),(50, .init(lightUIColor: .blue))])
            funnelInterface.inputLegendTitles = ["2019", "2020", "2021", "2022","2019", "2020", "2021", "2022", "2023", "2024"]
            funnelInterface.displayDataMode = .mix
            var interface = LiteChartViewInterface(contentInterface: funnelInterface)
            interface.isShowChartTitleString = true
            interface.chartTitleString = "收入逐年减少"
            
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
        self.timer?.cancel()
        let timer = DispatchSource.makeTimerSource(queue: .main)
        timer.schedule(deadline: .now(), repeating: .milliseconds(1))
        timer.setEventHandler(handler: {
            [weak self] in
            self?.timerLabel?.text = String(CACurrentMediaTime())
        })
        timer.resume()
        self.timer = timer
        self.displayView?.startAnimation(animation: interface)
    }
    
    @objc func stopAnimation() {
        self.displayView?.stopAnimation()
        self.timer?.cancel()
    }
    
    @objc func pauseAnimation() {
        self.displayView?.pauseAnimation()
    }
    
    @objc func continueAnimation() {
        self.displayView?.continueAnimation()
    }


}
