//
//  HomeModel.swift
//  CCMN
//
//  Created by Vitalii Poltavets on 3/10/19.
//  Copyright © 2019 unit. All rights reserved.
//

import Foundation
import Charts

enum UserDifference {
    case up(Int)
    case down(Int)
    case equel(Int)
}

final class HomeModel {
    
    private let campusInfo: NCCampusImportantInfo?
    
    private let coordinator: NCHomeCoordinator
    private let network: NCNetworkManager
    private var todayVisitorsTimer: Timer!
    private var usersOnlineTimer: Timer!
    
    var buildingName: String {
        return campusInfo?.buildingName ?? "Unknown"
    }
    var floorsNames: [String] {
        return campusInfo?.floorNames ?? [""]
    }
    
    init(coordinator: NCHomeCoordinator, campusInfo: NCCampusImportantInfo?, network: NCNetworkManager) {
        self.coordinator = coordinator
        self.campusInfo = campusInfo
        self.network = network
    }
    
    func usersOnline(completion: @escaping (Int, UserDifference) -> Void) {
        var previousResult: Int!
        usersOnlineTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            self.network.usersOnline { result in
                guard let count = result else { return }
                
                if previousResult == nil { previousResult = count }
                let difference = count - previousResult 
                var diff: UserDifference!
                if difference < 0 {
                    diff = UserDifference.down(difference)
                } else if difference > 0 {
                    diff = UserDifference.up(difference)
                } else {
                    diff = UserDifference.equel(difference)
                }
                completion(count, diff)
                previousResult = count
            }
        }
        usersOnlineTimer.fire()
    }
    
    func todayVisitors(completion: @escaping (Int, UserDifference) -> Void) {
        var previousResult: Int!
        todayVisitorsTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            self.network.todayVisitors { result in
                guard let count = result else { return }
                
                if previousResult == nil { previousResult = count }
                let difference = count - previousResult
                var diff: UserDifference!
                if difference < 0 {
                    diff = UserDifference.down(difference)
                } else if difference > 0 {
                    diff = UserDifference.up(difference)
                } else {
                    diff = UserDifference.equel(difference)
                }
                completion(count, diff)
                previousResult = count
            }
        }
        todayVisitorsTimer.fire()
    }
    
    func todayKPI(completion: @escaping (PieChartData) -> Void) {
        Timer.scheduledTimer(withTimeInterval: 300, repeats: true) { _ in
            self.network.todayKPI { result in
                guard let kpi = result else { return }
                
                let entries = (kpi.topManufacturers.manufacturerCounts.map { $0.key }).map { i -> PieChartDataEntry in
                    let value = kpi.topManufacturers.manufacturerCounts[i]
                    return PieChartDataEntry(value: Double(value!), label: i)
                }
                
                let set = PieChartDataSet(values: entries, label: "")
                set.drawIconsEnabled = false
                set.sliceSpace = 2
                set.colors = ChartColorTemplates.vordiplom()
                
                let data = PieChartData(dataSet: set)
                
                let pFormatter = NumberFormatter()
                pFormatter.numberStyle = .none
                
                data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
                data.setValueFont(NCApplicationConstants.medium13)
                data.setValueTextColor(UIColor.gray)
                
                completion(data)
            }
        }.fire()
    }
    
    func allClients(completion: @escaping (String, String, String) -> Void) {
        var oldClients: [NCClientEntity]?
        
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { [weak self] _ in
            guard let `self` = self else { return }
            self.network.allClients { result in
                guard let clients = result else { return }
                let newClient = clients.filter {
                    if oldClients != nil, !oldClients!.contains($0) {
                        return true
                    }
                    return false
                    }.first
                oldClients = clients
                if let user = newClient {
                    completion(user.macAddress, user.userName, user.floorName(floorNames: self.floorsNames))
                }
            }
            }.fire()
    }
    
    func searchUser(by text: String, completion: @escaping (NCClientEntity?, Int?) -> Void) {
        if text.matches("^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$") {
            network.searchUser(byMacAddress: text, completion: { [weak self] result in
                self?.checkWhere(result, completion: completion)
            })
        } else {
            network.searchUser(byUsername: text) { [weak self] result in
                self?.checkWhere(result, completion: completion)
            }
        }
    }
    
    func redirectWithUser(_ user: NCClientEntity, withIndex index: Int) {
        NCSelectedUser.shared.macAddress = user.macAddress
        coordinator.selectTabIndex(index)
    }
    
    func refreshUserData() {
        todayVisitorsTimer.fire()
        usersOnlineTimer.fire()
    }
    
    private func checkWhere(_ result: [NCClientEntity]?, completion: @escaping (NCClientEntity?, Int?) -> Void) {
        guard let user = result?.first else { completion(nil, nil); return }
        let floorName = user.floorName(floorNames: self.floorsNames)
        /// This is pain :)
        if floorName.contains("1") {
            completion(user, 2)
        } else if floorName.contains("2") {
            completion(user, 3)
        } else if floorName.contains("3") {
            completion(user, 4)
        } else {
            completion(nil, nil)
        }
    }

    
}


extension String {
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}

