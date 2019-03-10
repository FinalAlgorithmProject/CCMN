//
//  StatisticRangeEntity.swift
//  CCMN
//
//  Created by Vitalii Poltavets on 3/2/19.
//  Copyright © 2019 unit. All rights reserved.
//

import Foundation

struct NCStatisticRangeEntity {
    let siteId: Int = NCUserDefaultsService.siteId
    let startDate: String
    let endDate: String?
}
