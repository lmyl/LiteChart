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
        
        var configure = BarChartViewConfigure(textColor: .init(lightUIColor: .black), coupleTitle: ["一月", "二月", "三月", "四月"], valueTitle: ["10", "30", "60"], inputDatas: [(.init(lightUIColor: .blue), [("20", 0.2), ("30", 0.3), ("40", 0.4), ("50", 0.5)]), (.init(lightUIColor: .green), [("20", 0.2), ("30", 0.3), ("40", 0.4), ("50", 0.5)])], direction: .leftToRight, borderColor: .init(lightUIColor: .black), borderStyle: .halfSurrounded, xDividingPoints: [.init(dividingLineStyle: .dotted, dividingLineColor: .init(lightUIColor: .yellow), location: 0.1), .init(dividingLineStyle: .dotted, dividingLineColor: .init(lightUIColor: .yellow), location: 0.3), .init(dividingLineStyle: .dotted, dividingLineColor: .init(lightUIColor: .yellow), location: 0.6)], yDividingPoints: [])
        
        let backgroundView = BarChartView(configure: configure)
        self.view.addSubview(backgroundView)
        
        backgroundView.snp.makeConstraints{
            make in
            make.center.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(300)
        }
        
        
    }


}

