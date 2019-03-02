//
//  KpiStatisticEntity.swift
//  CCMN
//
//  Created by Vitalii Poltavets on 3/2/19.
//  Copyright © 2019 unit. All rights reserved.
//

import Foundation

struct KpiStatisticEntity: Codable {
    let visitorCount: Int
    let totalPasserbyCount: Int
    let totalVisitorCount: Int
    let totalConnectedCount: Int
    let averageDwell: Double
    
    let averageDwellByLevels: AverageDwellByLevels
    let topManufacturers: TopManufacturers
    let peakSummary: PeakSummary
    
}

struct AverageDwellByLevels: Codable {
    let fiveToThirtyMinutes: DwellStatistic
    let thirtyToSixtyMinutes: DwellStatistic
    let oneToFiveHours: DwellStatistic
    let fiveToEightHours: DwellStatistic
    let eightPlusHours: DwellStatistic
    
    enum CodingKeys: String, CodingKey {
        case fiveToThirtyMinutes = "FIVE_TO_THIRTY_MINUTES"
        case thirtyToSixtyMinutes = "THIRTY_TO_SIXTY_MINUTES"
        case oneToFiveHours = "ONE_TO_FIVE_HOURS"
        case fiveToEightHours = "FIVE_TO_EIGHT_HOURS"
        case eightPlusHours = "EIGHT_PLUS_HOURS"
    }
}

struct DwellStatistic: Codable {
    let average: Double
    let count: Int
    
    enum CodingKeys: String, CodingKey {
        case average = "average"
        case count = "count"
    }
}

struct TopManufacturers: Codable {
    let name: String
    let count: Int
    let manufacturerCounts: [String: Int]
}

struct PeakSummary: Codable {
    let peakHour: Int
    let peakDate: String?
    let peakWeek: Int
}
