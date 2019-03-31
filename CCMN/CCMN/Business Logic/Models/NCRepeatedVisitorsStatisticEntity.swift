//
//  RepeatedVisitors.swift
//  CCMN
//
//  Created by Vitalii Poltavets on 3/2/19.
//  Copyright © 2019 unit. All rights reserved.
//

import Foundation

struct NCRepeatedVisitorsStatisticEntity: Codable {
    let daily: Int
    let weekly: Int
    let occasional: Int
    let firstTime: Int
    let yesterday: Int
    
    enum CodingKeys: String, CodingKey {
        case daily = "DAILY"
        case weekly = "WEEKLY"
        case occasional = "OCCASIONAL"
        case firstTime = "FIRST_TIME"
        case yesterday = "YESTERDAY"
    }
}
