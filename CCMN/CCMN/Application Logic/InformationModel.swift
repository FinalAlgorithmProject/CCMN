//
//  InformationModel.swift
//  CCMN
//
//  Created by Vitalii Poltavets on 2/24/19.
//  Copyright © 2019 unit. All rights reserved.
//

import Foundation

struct InformationModel {
    
    private var networkService = NetworkManager.shared
    
    
    func getOnlineUsers(completion: @escaping (Int) -> Void) {
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { timer in
            self.networkService.usersOnline(completion: completion)
        }
    }
    
    func getTodayVisitors(completion: @escaping (Int) -> Void) {
        networkService.todayVisitors(completion: completion)
    }
    
    func campusInformation(completion: @escaping (String, String) -> Void) {
        networkService.campusInformation { campus in
            guard let campusModel = campus else { return }
            guard let buildingName = campusModel.campusCounts.first?.buildingCounts.first?.buildingName else { return }
            let totalFloors = String(campusModel.totalFloors)
            completion(buildingName, totalFloors)
        }
    }
    
}
