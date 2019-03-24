//
//  NCClientEntity.swift
//  CCMN
//
//  Created by Vitalii Poltavets on 3/23/19.
//  Copyright © 2019 unit. All rights reserved.
//

import Foundation

struct NCClientEntity: Codable {
    
    let macAddress: String
    let userName: String
    let mapInfo: MapInfo
    
    func floorName(floorNames: [String]) -> String {
        let name = floorNames.first { mapInfo.mapHierarchyString.contains($0) }?
            .replacingOccurrences(of: "_", with: " ")
        return name ?? "???"
    }
}

struct MapInfo: Codable {
    let mapHierarchyString: String
}

extension NCClientEntity: Equatable {
    static func == (lhs: NCClientEntity, rhs: NCClientEntity) -> Bool {
        return lhs.macAddress == rhs.macAddress
    }
}