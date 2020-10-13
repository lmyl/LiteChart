//
//  LiteChartParametersProcesser.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/8.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation
import UIKit

protocol LiteChartParametersProcesser {
    func checkInputDatasParameterInvalid() throws
    
    func computeLegendViews() -> UIView?
    
    func computeContentView() -> LiteChartContentView
}
