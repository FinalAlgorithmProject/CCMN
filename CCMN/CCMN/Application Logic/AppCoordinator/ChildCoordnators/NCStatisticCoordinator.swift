//
//  NCStatisticCoordinator.swift
//  CCMN
//
//  Created by Vitalii Poltavets on 3/10/19.
//  Copyright © 2019 unit. All rights reserved.
//

import Foundation

class NCStatisticCoordinator: NCBaseCoordinator {
    
    func statisticViewController() -> StatisticViewController {
        let viewController = StatisticViewController.init(nibName: StatisticViewController.className, bundle: nil)
        let network = NCNetworkManager.shared
        viewController.model = StatisticModel(coordinator: self, network: network)
        return viewController
    }

    func openRepeatedVisitorsCharts(with startDate: String?, endDate: String?) {
        let viewController = NCRepeatedVisitorsChartViewController.init(nibName: NCRepeatedVisitorsChartViewController.className, bundle: nil)
        let network = NCNetworkManager.shared
        viewController.model = NCRepeatedVisitorsModel(coordinator: self, network: network, startDate: startDate, endDate: endDate)
        pushViewController(viewController)
    }
    
}
