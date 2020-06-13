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
        }
    }
}

extension ChartError: LocalizedError {
    var errorDescription: String? {
        return self.description
    }
}
