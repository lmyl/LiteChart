//
//  CALayer+SyncTimeSystem.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/10/19.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation
import UIKit

extension CALayer {
    func syncTimeSystemToFather() {
        self.beginTime = 0
        self.timeOffset = 0
        self.speed = 1
    }
}
