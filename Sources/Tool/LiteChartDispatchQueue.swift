//
//  LiteChartDispatchQueue.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/8/30.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation

enum LiteChartDispatchQueue {
    static let asyncDrawQueue = DispatchQueue(label: "library.liteChart", qos: .userInitiated, attributes: .concurrent)
    
    static let asyncDrawDoneQueue = DispatchQueue.main
}
