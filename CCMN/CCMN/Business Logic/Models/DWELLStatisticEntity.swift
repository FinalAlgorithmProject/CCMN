//
//  DWELLStatisticEntity.swift
//  CCMN
//
//  Created by Vitalii Poltavets on 3/2/19.
//  Copyright © 2019 unit. All rights reserved.
//

import Foundation

struct DWELLStatisticEntity: Codable {
    let fiveToThirtyMinutes: Int
    let thirtyToSixtyMinutes: Int
    let oneToFiveHours: Int
    let fiveToEightHours: Int
    let eightPlusHours: Int
    
    enum CodingKeys: String, CodingKey {
        case fiveToThirtyMinutes = "FIVE_TO_THIRTY_MINUTES"
        case thirtyToSixtyMinutes = "THIRTY_TO_SIXTY_MINUTES"
        case oneToFiveHours = "ONE_TO_FIVE_HOURS"
        case fiveToEightHours = "FIVE_TO_EIGHT_HOURS"
        case eightPlusHours = "EIGHT_PLUS_HOURS"
    }
}
