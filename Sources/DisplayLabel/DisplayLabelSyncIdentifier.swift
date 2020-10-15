//
//  DisplayLabelSyncIdentifier.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/10/15.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation

struct DisplayLabelSyncIdentifier {
    let syncCenterIdentifier: String
    
    let syncIdentifierType: DisplayLabelSyncIdentifierType
}

extension DisplayLabelSyncIdentifier {
    var identifier: Notification.Name {
        switch syncIdentifierType {
        case .funalLegendTitleLabel:
            return .init("updateFunalLegendTitleLabelFont" + "-" + syncCenterIdentifier)
        case .funalTitleLabel:
            return .init("updateFunalTitleLabelFont" + "-" + syncCenterIdentifier)
        case .pieLegendTitleLabel:
            return .init("updatePieLegendTitleLabelFont" + "-" + syncCenterIdentifier)
        case .pieTitleLabel:
            return .init("updatePieTitleLabelFont" + "-" + syncCenterIdentifier)
        case .barLegendTitleLabel:
            return .init("updateBarLegendTitleLabelFont" + "-" + syncCenterIdentifier)
        case .barTitleLabel:
            return .init("updateBarTitleLabelFont" + "-" + syncCenterIdentifier)
        case .barUnitTitleLabel:
            return .init("updateBarUnitTitleLabelFont" + "-" + syncCenterIdentifier)
        case .barValueTitleLabel:
            return .init("updateBarValueTitleLabelFont" + "-" + syncCenterIdentifier)
        case .barCoupleTitleLabel:
            return .init("updateBarCoupleTitleLabelFont" + "-" + syncCenterIdentifier)
        case .lineCoupleTitleLabel:
            return .init("updateLineCoupleTitleLabelFont" + "-" + syncCenterIdentifier)
        case .lineLegendTitleLabel:
            return .init("updateLineLegendTitleLabelFont" + "-" + syncCenterIdentifier)
        case .lineTitleLabel:
            return .init("updateLineTitleLabelFont" + "-" + syncCenterIdentifier)
        case .lineValueTitleLabel:
            return .init("updateLineValueTitleLabelFont" + "-" + syncCenterIdentifier)
        case .lineUnitTitleLabel:
            return .init("updateLineUnitTitleLabelFont" + "-" + syncCenterIdentifier)
        case .pointsCoupleTitleLabel:
            return .init("updatePointsCoupleTitleLabelFont" + "-" + syncCenterIdentifier)
        case .scatterLegendTitleLabel:
            return .init("updateScatterLegendTitleLabelFont" + "-" + syncCenterIdentifier)
        case .pointsValueTitleLabel:
            return .init("updatePointsValueTitleLabelFont" + "-" + syncCenterIdentifier)
        case .pointsUnitTitleLabel:
            return .init("updatePointsUnitTitleLabelFont" + "-" + syncCenterIdentifier)
        case .bubbleLegendTitleLabel:
            return .init("updateBubbleLegendTitleLabelFont" + "-" + syncCenterIdentifier)
        case .radarLegendTitleLabel:
            return .init("updateRadarLegendTitleLabelFont" + "-" + syncCenterIdentifier)
        case .radarCoupleTitleLabel:
            return .init("updateRadarCoupleTitleLabelFont" + "-" + syncCenterIdentifier)
        case .none:
            return .init(" ")
        }
    }
}

extension DisplayLabelSyncIdentifier {
    private init() {
        self.syncCenterIdentifier = ""
        self.syncIdentifierType = .none
    }
    
    static let emptyIdentifier = DisplayLabelSyncIdentifier()
}

extension DisplayLabelSyncIdentifier: Equatable {
    
}

extension DisplayLabelSyncIdentifier: Hashable {
    
}
