//
//  StatisticModel.swift
//  CCMN
//
//  Created by Vitalii Poltavets on 3/10/19.
//  Copyright © 2019 unit. All rights reserved.
//

import Foundation
import Charts

final class StatisticModel {
    
    private let coordinator: NCStatisticCoordinator
    private let network: NCNetworkManager
    
    var startDate: String?
    var endDate: String?
    
    init(coordinator: NCStatisticCoordinator, network: NCNetworkManager) {
        self.coordinator = coordinator
        self.network = network
    }
    
    
    func openRepeatedVisitors() {
        coordinator.openRepeatedVisitorsCharts(with: startDate, endDate: endDate)
    }
    
    func openDwellTimeStatistic() {
        coordinator.openDwellTimeCharts(with: startDate, endDate: endDate)
    }
    
    func openPasserbyStatistic() {
        coordinator.openPasserbyCharts(with: startDate, endDate: endDate)
    }
 
    func openConnectedUsers() {
        coordinator.openConnectedUsersCharts(with: startDate, endDate: endDate)
    }
    
    func openVisitorsStatistic() {
        coordinator.openVisitorsCharts(with: startDate, endDate: endDate)
    }
}
