//
//  WeakObjectPackage.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/9/1.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation

class WeakObjectPackage<T: AnyObject> {
    
    private(set) weak var value: T?
    
    init(value: T) {
        self.value = value
    }
}
