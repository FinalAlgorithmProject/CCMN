//
//  StatisticDateEntity.swift
//  CCMN
//
//  Created by Vitalii Poltavets on 3/2/19.
//  Copyright © 2019 unit. All rights reserved.
//

import Foundation

struct NCStatisticDateEntity {
    let siteId: Int = NCUserDefaultsService.siteId
    let date: String // format: yyyy-mm-dd
}
