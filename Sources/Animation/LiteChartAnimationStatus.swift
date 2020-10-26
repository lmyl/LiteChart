//
//  LiteChartAnimationStatus.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/10/18.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation

public enum LiteChartAnimationStatus {
    case ready
    case running
    case pause
    case cancel
    case finish
}

extension LiteChartAnimationStatus {
    internal var priority: Int {
        switch self {
        case .ready:
            return 1
        case .running:
            return 5
        case .pause:
            return 4
        case .cancel:
            return 3
        case .finish:
            return 2
        }
    }
    
    internal func compactAnimatoinStatus(another: LiteChartAnimationStatus) -> Self {
        if self.priority >= another.priority {
            return self
        } else {
            return another
        }
    }
}
