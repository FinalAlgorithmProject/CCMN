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
    
    func refreshUserData() {
        todayVisitorsTimer.fire()
        nowDevicesConnectedTimer.fire()
    }
    
}
