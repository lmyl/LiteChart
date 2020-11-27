//
//  LiteChartParametersProcesser.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/8.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation
import UIKit

/// The protocal for paramters handling
public protocol LiteChartParametersProcesser {
    /// Check whether the input data is legal
    func checkInputDatasParameterInvalid() throws
    
    /// Compute legend views of the whole chart
    /// - Parameter syncCenterIdentifier: Uniquely identifiable string to identify chart's type, UUID is used inside the framework
    func computeLegendViews(syncCenterIdentifier: String) -> UIView?
    
    /// Compute content view of the whole chart
    /// - Parameter syncCenterIdentifier: Uniquely identifiable string to identify chart's type.
    func computeContentView(syncCenterIdentifier: String) -> LiteChartContentView
}
