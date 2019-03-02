//
//  StatisticRangeEntity.swift
//  CCMN
//
//  Created by Vitalii Poltavets on 3/2/19.
//  Copyright © 2019 unit. All rights reserved.
//

import Foundation

struct StatisticRangeEntity {
    let siteId: Int = UserDefaultsService.siteId
    let startDate: String
    let endDate: String?
}
