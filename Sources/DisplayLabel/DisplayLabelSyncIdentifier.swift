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
    case funalLegendTitleLabel
    case funalTitleLabel
    case pieLegendTitleLabel
    case pieTitleLabel
    case barLegendTitleLabel
    case barUnitTitleLabel
    case barTitleLabel
    case barValueTitleLabel
    case barCoupleTitleLabel
    case lineCoupleTitleLabel
}


extension DisplayLabelSyncIdentifier: Hashable {
    
}

extension DisplayLabelSyncIdentifier {
    var identifier: Notification.Name {
        switch self {
        case .funalLegendTitleLabel:
            return .init("updateFunalLegendTitleLabelFont")
        case .funalTitleLabel:
            return .init("updateFunalTitleLabelFont")
        case .pieLegendTitleLabel:
            return .init("updatePieLegendTitleLabelFont")
        case .pieTitleLabel:
            return .init("updatePieTitleLabelFont")
        case .barLegendTitleLabel:
            return .init("updateBarLegendTitleLabelFont")
        case .barTitleLabel:
            return .init("updateBarTitleLabelFont")
        case .barUnitTitleLabel:
            return .init("updateBarUnitTitleLabelFont")
        case .barValueTitleLabel:
            return .init("updateBarValueTitleLabelFont")
        case .barCoupleTitleLabel:
            return .init("updateBarCoupleTitleLabelFont")
        case .lineCoupleTitleLabel:
            return .init("updateLineCoupleTitleLabelFont")
        case .none:
            return .init(" ")
        }
    }
}
