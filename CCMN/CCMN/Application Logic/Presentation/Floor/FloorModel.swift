//
//  FloorModel.swift
//  CCMN
//
//  Created by Vitalii Poltavets on 3/16/19.
//  Copyright © 2019 unit. All rights reserved.
//

import UIKit

enum FloorLoading {
    case low(Int)
    case medium(Int)
    case high(Int)
}

final class FloorModel {
    
    private let network: NCNetworkManager
    private let floorName: String
    private let floorMaxCapacity: Int
    private let campusInfo: NCCampusImportantInfo?
    
    private var clientsTimer: Timer!
    
    init(network: NCNetworkManager, floorName: String, floorMaxCapacity: Int, campusInfo: NCCampusImportantInfo?) {
        self.network = network
        self.floorName = floorName
        self.floorMaxCapacity = floorMaxCapacity
        self.campusInfo = campusInfo
        
        print(self.floorMaxCapacity)
    }
    
    func getImage(completion: @escaping (UIImage?) -> Void) {
        guard let campus = campusInfo else { completion(nil); return }
        network.floorImageName(by: campus, floorName: floorName, completion: completion)
    }
    
    func clientsInfo(completion: @escaping (_ points: [Int: CGPoint], _ loading: FloorLoading) -> Void) {
        clientsTimer = Timer.scheduledTimer(withTimeInterval: 15, repeats: true) { [weak self] _ in
            guard let `self` = self else { return }
            self.network.allClients { result in
                guard let allClients = result else { return }
                
                let floorNames = self.campusInfo!.floorNames
                let students = allClients
                    .filter { $0.floorName(floorNames: floorNames) == self.floorName
                        .replacingOccurrences(of: "_", with: " ") }
                let points = students.reduce([Int: CGPoint]()) { dict, student -> [Int: CGPoint] in
                    var dict = dict
                    dict[student.macAddress.hashValue] = CGPoint(x: student.mapCoordinate.x / 2, y: student.mapCoordinate.y / 2)
                    return dict
                }
                let loading = self.floorLoading(students.count)
                
                completion(points, loading)
            }
        }
        reloadMap()
    }
    
    func reloadMap() {
        clientsTimer.fire()
    }
    
    private func floorLoading(_ student: Int) -> FloorLoading {
        let percentage = (Double(student) * 100 / Double(floorMaxCapacity))
        
        if percentage >= 75 {
            return FloorLoading.high(student)
        } else if percentage >= 50 {
            return FloorLoading.medium(student)
        } else {
            return FloorLoading.low(student)
        }
    }
}

/*
 "floorDimension": {
 "length": 771,
 "width": 1551,
 "height": 10,
 "offsetX": 0,
 "offsetY": 0,
 "unit": "FEET"
 },
 */

// b4:9c:df:04:f7:ab - my mac address
// 38:a4:ed:1c - tgogol

