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
    
    let inRangeModel = StatisticRangeEntity(startDate: "2019-03-01", endDate: nil)
    let specDateModel = StatisticDateEntity(date: "2019-03-02")
    
    // Nah ..
    func getOnlineUsers(completion: @escaping (Int?) -> Void) {
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { timer in
            self.networkService.usersOnline(completion: completion)
        }
    }
    
    func getTodayVisitors(completion: @escaping (Int?) -> Void) {
        networkService.todayVisitors(completion: completion)
    }
    
    func campusInformation(completion: @escaping (String, String, [String]) -> Void) {
        networkService.campusInformation { result in
            guard let campusModel = result else { return }
            let totalFloors = String(campusModel.totalFloors)
            let buildingName = campusModel.campusCounts.first!
                .buildingCounts.first!.buildingName
            let floorsName = campusModel.campusCounts.first!
                .buildingCounts.first!.floorCounts.map { $0.floorName }
            completion(buildingName, totalFloors, floorsName)
        }
    }
    
    func searchUserByMacAddress() {
        let macAddress = "b4:9c:df:04:f7:ab"
        networkService.searchUser(byMacAddress: macAddress) {
            
        }
    }
    
    func searchUserByUserName() {
        let username = "pizza"
        networkService.searchUser(byUsername: username) {
            
        }
    }
    
    func todayKPI() {
        networkService.todayKPI {
            
        }
    }
    
    
    // ---------------------------- Stats Data ----------------------------
    
    func repeatedVisitorsInRange() {
        networkService.repeatedVisitorsInRange(model: inRangeModel) { result in
            
        }
    }
    
    func repeatedVisitorsForDate() {
        networkService.repeatedVisitorsForSpecificDate(specDateModel) { result in
            
        }
    }
    
    func dwellInRange() {
        networkService.dwellInRange(model: inRangeModel) { result in

        }
    }

    func dwellForDate() {
        networkService.dwellForSpecificDate(specDateModel) { result in

        }
    }

    func passerbyInRange() {
        networkService.passerbyInRange(model: inRangeModel) { result in

        }
    }

    func passerbyForDate() {
        networkService.passerbyForSpecificDate(specDateModel) { result in

        }
    }
    
    func visitorsInRange() {
        networkService.visitorsInRange(model: inRangeModel) { result in
            
        }
    }
    
    func visitorsForDate() {
        networkService.visitorsForSpecificDate(specDateModel) { result in
            
        }
    }
    
}



























