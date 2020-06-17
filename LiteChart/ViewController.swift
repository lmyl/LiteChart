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
        
        let configure = LineChartViewConfigure(textColor: .init(lightUIColor: .black), coupleTitle: ["一月", "二月", "三月", "四月"], valueTitle: ["20", "40", "60", "80"], inputDatas: [(LiteChartDarkLightColor(lightUIColor: .orange), .dotted, .circle, [("20", CGPoint(x: 0.1, y: 0.1)), ("30", CGPoint(x: 0.2, y: 0.15)), ("60", CGPoint(x: 0.3, y: 0.3)), ("80", CGPoint(x: 0.4, y: 0.4))]), (LiteChartDarkLightColor(lightUIColor: .blue), .solid, .pentagram, [("10", CGPoint(x: 0.1, y: 0.05)), ("50", CGPoint(x: 0.2, y: 0.25)), ("20", CGPoint(x: 0.3, y: 0.1)), ("70", CGPoint(x: 0.4, y: 0.35))])], borderColor: .init(lightUIColor: .black), borderStyle: .halfSurrounded, axisOriginal: .zero, axisColor: .init(lightUIColor: .green), xDividingPoints: [.init(dividingLineStyle: .dotted, dividingLineColor: .init(lightUIColor: .systemPink), location: 0.1), .init(dividingLineStyle: .dotted, dividingLineColor: .init(lightUIColor: .systemPink), location: 0.2), .init(dividingLineStyle: .dotted, dividingLineColor: .init(lightUIColor: .systemPink), location: 0.3), .init(dividingLineStyle: .dotted, dividingLineColor: .init(lightUIColor: .systemPink), location: 0.4)], yDividingPoints: [.init(dividingLineStyle: .dotted, dividingLineColor: .init(lightUIColor: .systemPink), location: 0.1), .init(dividingLineStyle: .dotted, dividingLineColor: .init(lightUIColor: .systemPink), location: 0.2), .init(dividingLineStyle: .dotted, dividingLineColor: .init(lightUIColor: .systemPink), location: 0.3), .init(dividingLineStyle: .dotted, dividingLineColor: .init(lightUIColor: .systemPink), location: 0.4)], valueUnitString: nil, coupleUnitString: nil)
        
        let view = LineChartView(configure: configure)
        self.view.addSubview(view)
        view.snp.updateConstraints{
            make in
            make.width.equalToSuperview()
            make.center.equalToSuperview()
            make.height.equalTo(300)
        }
        
    }


}

