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
    let mapCoordinate: MapCoordinate
    
    func floorName(floorNames: [String]) -> String {
        let name = floorNames.first { mapInfo.mapHierarchyString.contains($0) }?
            .replacingOccurrences(of: "_", with: " ")
        return name ?? "???"
    }
}

struct MapInfo: Codable {
    let mapHierarchyString: String
    let floorDimension: FloorDimension
}

struct FloorDimension: Codable {
    let length: Int
    let width: Int
    let height: Int
    let offsetX: Int
    let offsetY: Int
    let unit: String
    
    enum CodingKeys: String, CodingKey {
        case length = "length"
        case width = "width"
        case height = "height"
        case offsetX = "offsetX"
        case offsetY = "offsetY"
        case unit = "unit"
    }
}

struct MapCoordinate: Codable {
    let x: Double
    let y: Double
    let z: Int
    let unit: String
    
    enum CodingKeys: String, CodingKey {
        case x = "x"
        case y = "y"
        case z = "z"
        case unit = "unit"
    }
}

extension NCClientEntity: Equatable {
    static func == (lhs: NCClientEntity, rhs: NCClientEntity) -> Bool {
        return lhs.macAddress == rhs.macAddress
    }
}
