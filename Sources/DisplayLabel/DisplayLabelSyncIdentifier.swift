//
//  DisplayLabelSyncIdentifier.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/8/31.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation

enum DisplayLabelSyncIdentifier {
    case none
    case coupleTitleLabel
    case legendTitleLabel
    case funalTitleLabel
}


extension DisplayLabelSyncIdentifier: Hashable {
    
}

extension DisplayLabelSyncIdentifier {
    var identifier: Notification.Name {
        switch self {
        case .coupleTitleLabel:
            return .init("updateCoupleTitleLabelFont")
        case .legendTitleLabel:
            return .init("updateLegendTitleLabelFont")
        case .funalTitleLabel:
            return .init("updateFunalTitleLabelFont")
        case .none:
            return .init(" ")
        }
    }
}
