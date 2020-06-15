//
//  LiteChartDatas.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/8.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation

enum LiteChartDatas {
    case funal(inputDatas: [(Double, LiteChartDarkLightColor)])
    case pie(inputDatas: [(Double, LiteChartDarkLightColor)])
    case bar(inputDatas: [(LiteChartDarkLightColor, [Double])], coupleTitle: [String])
}
