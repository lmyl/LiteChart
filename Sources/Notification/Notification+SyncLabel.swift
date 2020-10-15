//
//  Notification+SyncLabel.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/9/1.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation

extension Notification.Name {
    static var updateLabelFont: (_ syncCenterIdentifier: String) -> Self = {
        Notification.Name.init("LiteChartUpdateLabelFont" + "-" + $0)
    }
}
