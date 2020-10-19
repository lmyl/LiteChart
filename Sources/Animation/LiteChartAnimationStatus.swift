//
//  LiteChartAnimationStatus.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/10/18.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation

enum LiteChartAnimationStatus {
    case ready
    case running
    case pause
    case cancel
    case finish
}

extension LiteChartAnimationStatus {
    var priority: Int {
        switch self {
        case .ready:
            return 1
        case .running:
            return 5
        case .pause:
            return 4
        case .cancel:
            return 2
        case .finish:
            return 3
        }
    }
    
    func compactAnimatoinStatus(another: LiteChartAnimationStatus) -> Self {
        if self.priority >= another.priority {
            return self
        } else {
            return another
        }
    }
}
