//
//  LiteChartContentView.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/10/12.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit

class LiteChartContentView: UIView, LiteChartAreaLayoutGuide {
    var areaLayoutGuide: UILayoutGuide {
        self.safeAreaLayoutGuide
    }
}
