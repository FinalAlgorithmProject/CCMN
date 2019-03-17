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
    var endDate: String? = nil
    
    init(coordinator: NCStatisticCoordinator, network: NCNetworkManager) {
        self.coordinator = coordinator
        self.network = network
    }
    
    func openRepeatedVisitors() {
        coordinator.openRepeatedVisitorsCharts(with: startDate, endDate: endDate)
    }
 
}
