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
    case lineLegendTitleLabel
    case lineTitleLabel
    case lineValueTitleLabel
    case lineUnitTitleLabel
    case pointsCoupleTitleLabel
    case scatterLegendTitleLabel
    case pointsValueTitleLabel
    case pointsUnitTitleLabel
    case bubbleLegendTitleLabel
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
        case .lineLegendTitleLabel:
            return .init("updateLineLegendTitleLabelFont")
        case .lineTitleLabel:
            return .init("updateLineTitleLabelFont")
        case .lineValueTitleLabel:
            return .init("updateLineValueTitleLabelFont")
        case .lineUnitTitleLabel:
            return .init("updateLineUnitTitleLabelFont")
        case .pointsCoupleTitleLabel:
            return .init("updatePointsCoupleTitleLabelFont")
        case .scatterLegendTitleLabel:
            return .init("updateScatterLegendTitleLabelFont")
        case .pointsValueTitleLabel:
            return .init("updatePointsValueTitleLabelFont")
        case .pointsUnitTitleLabel:
            return .init("updatePointsUnitTitleLabelFont")
        case .bubbleLegendTitleLabel:
            return .init("updateBubbleLegendTitleLabelFont")
        case .none:
            return .init(" ")
        }
    }
}
