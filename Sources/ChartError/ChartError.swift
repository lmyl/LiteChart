//
//  ChartError.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/8.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation


enum ChartError: Error {
    case inputDatasNotTrueSorted
    case inputDatasMustPositive
    case inputDatasNumbersNotMatchedCoupleTitle
    case inputDatasNumberMustEqualForCouple
    case inputDatasNumberLessThanLimit
    case inputDatasMustLessAndEqualThan(number: Double)
}


extension ChartError: CustomStringConvertible {
    var description: String {
        switch self {
        case .inputDatasNotTrueSorted:
            return "The data entered is not in the correct order"
        case .inputDatasMustPositive:
            return "The data entered must be positive"
        case .inputDatasNumbersNotMatchedCoupleTitle:
            return "The data entered must match in couple title"
        case .inputDatasNumberMustEqualForCouple:
            return "The amount of data in each group must be equal"
        case .inputDatasNumberLessThanLimit:
            return "The amount of data in each group must large than minimum"
        case .inputDatasMustLessAndEqualThan(let number):
            return "The data entered must less and qeual than \(number)"
        }
    }
}

extension ChartError: LocalizedError {
    var errorDescription: String? {
        return self.description
    }
}
