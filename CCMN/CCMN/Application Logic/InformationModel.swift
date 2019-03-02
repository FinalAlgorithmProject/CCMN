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
    let startDate = "2019-03-01"
    let endDate: String? = nil
    let date = "2019-03-02"
    
    func getOnlineUsers(completion: @escaping (Int) -> Void) {
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { timer in
            self.networkService.usersOnline(completion: completion)
        }
    }
    
    func getTodayVisitors(completion: @escaping (Int) -> Void) {
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
    
    func repeatedVisitorsInRange() {
        networkService.repeatedVisitorsInRange(fromDate: startDate, to: endDate) { result in
            guard let statistic = result else { return }
        }
    }
    
    func repeatedVisitorsForDate() {
        networkService.repeatedVisitorsForSpecificDate(date) { result in
            guard let statistic = result else { return }
        }
    }
    
    func dwellInRange() {
        networkService.dwellInRange(fromDate: startDate, to: endDate) { result in
            guard let statistic = result else { return }
        }
    }
    
    func dwellForDate() {
        networkService.dwellForSpecificDate(date) { result in
            guard let statistic = result else { return }
        }
    }
    
    func passerbyInRange() {
        networkService.passerbyInRange(fromDate: startDate, to: endDate) { result in
             guard let statistic = result else { return }
        }
    }
    
    func passerbyForDate() {
        networkService.passerbyForSpecificDate(date) { result in
            guard let statistic = result else { return }
        }
    }
    
}
