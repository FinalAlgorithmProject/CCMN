//
//  CampusEntity.swift
//  CCMN
//
//  Created by Vitalii Poltavets on 2/24/19.
//  Copyright © 2019 unit. All rights reserved.
//

import Foundation

struct NCCampusImportantInfo {
    let campusName: String
    let buildingName: String
    let floorNames: [String]
}

struct NCCampusEntity: Codable {
    let totalCampuses: Int
    let totalBuildings: Int
    let totalFloors: Int
//    let totalAps: Int
    
    let campusCounts: [CampusInfoEntity]
    
    func decodeMyselfIntoCampusImportantInfo() -> NCCampusImportantInfo {
        let campusName = campusCounts.first?.campusName ?? "Unknown"
        let buildingName = campusCounts.first?.buildingCounts.first?.buildingName ?? "Unknown"
        let floorNames = campusCounts.first?.buildingCounts.first?.floorCounts.map { $0.floorName } ?? ["Unknown"]
        return NCCampusImportantInfo(campusName: campusName, buildingName: buildingName, floorNames: floorNames)
    }
}

struct CampusInfoEntity: Codable {
    let campusName: String
    let totalBuildings: Int
    let buildingCounts: [BuildingInfoEntity] // information about building
}

struct BuildingInfoEntity: Codable {
    let buildingName: String
    let totalFloors: Int
    let floorCounts: [FloorInfoEntity] // information about floors
}

struct FloorInfoEntity: Codable {
    let floorName: String
//    let apCount: Int
}
