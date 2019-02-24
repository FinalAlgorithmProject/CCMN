//
//  CampusEntity.swift
//  CCMN
//
//  Created by Vitalii Poltavets on 2/24/19.
//  Copyright © 2019 unit. All rights reserved.
//

import Foundation

struct CampusEntity: Codable {
    let totalCampuses: Int
    let totalBuildings: Int
    let totalFloors: Int
    let totalAps: Int
    
    let campusCounts: [CampusCount]
}

struct CampusCount: Codable {
    let campusName: String
    let totalBuildings: Int
    let buildingCounts: [BuildingCount]
}

struct BuildingCount: Codable {
    let buildingName: String
    let totalFloors: Int
    let floorCounts: [FloorCount]
}

struct FloorCount: Codable {
    let floorName: String
    let apCount: Int
}
