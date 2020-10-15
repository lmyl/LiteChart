//
//  DisplayLabelSyncIdentifierType.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/8/31.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation

enum DisplayLabelSyncIdentifierType {
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
    case radarLegendTitleLabel
    case radarCoupleTitleLabel
}


extension DisplayLabelSyncIdentifierType: Hashable {
    
}
