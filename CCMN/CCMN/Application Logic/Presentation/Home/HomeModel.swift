//
//  HomeModel.swift
//  CCMN
//
//  Created by Vitalii Poltavets on 3/10/19.
//  Copyright © 2019 unit. All rights reserved.
//

import Foundation

final class HomeModel {
    
    let buildingName: String
    
    private let coordinator: NCHomeCoordinator
    private let network: NCNetworkManager
    private var todayVisitorsTimer: Timer!
    private var nowDevicesConnectedTimer: Timer!
    
    init(coordinator: NCHomeCoordinator, buildingName: String, network: NCNetworkManager) {
        self.coordinator = coordinator
        self.buildingName = buildingName
        self.network = network
    }
    
    func devicesConnected(completion: @escaping (Int) -> Void) {
        nowDevicesConnectedTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            self.network.usersOnline { result in
                guard let count = result else { return }
                completion(count)
            }
        }
        nowDevicesConnectedTimer.fire()
    }
    
    func todayVisitors(completion: @escaping (Int) -> Void) {
        todayVisitorsTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            self.network.todayVisitors { result in
                guard let count = result else { return }
                completion(count)
            }
        }
        todayVisitorsTimer.fire()
    }
    
    func allClients(completion: @escaping (String, String, String) -> Void) {
        var oldClients: [NCClientEntity]?
        
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { [weak self] _ in
            self?.network.allClients { result in
                guard let clients = result else { return }
                let newClient = clients.filter {
                    if oldClients != nil, !oldClients!.contains($0) {
                        return true
                    }
                    return false
                    }.first
                oldClients = clients
                if let user = newClient {
                    completion(user.macAddress, user.userName, user.userFloor)
                }
            }
            }.fire()
    }
    
    func refreshUserData() {
        todayVisitorsTimer.fire()
        nowDevicesConnectedTimer.fire()
    }
    
}
