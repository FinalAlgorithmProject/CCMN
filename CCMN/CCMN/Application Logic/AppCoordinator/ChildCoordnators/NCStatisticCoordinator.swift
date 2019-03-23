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
    
    func openDwellTimeCharts(with startDate: String?, endDate: String?) {
        let viewController = NCDwellTimeViewController.init(nibName: NCDwellTimeViewController.className, bundle: nil)
        let network = NCNetworkManager.shared
        viewController.model = NCDwellTimeModel(coordinator: self, network: network, startDate: startDate, endDate: endDate)
        pushViewController(viewController)
    }
    
    func openPasserbyCharts(with startDate: String?, endDate: String?) {
        let viewController = NCPasserbyViewController.init(nibName: NCPasserbyViewController.className, bundle: nil)
        let network = NCNetworkManager.shared
        viewController.model = NCPasserbyModel(coordinator: self, network: network, startDate: startDate, endDate: endDate)
        pushViewController(viewController)
    }
    
    func openConnectedUsersCharts(with startDate: String?, endDate: String?) {
        let viewController = NCConnectedUsersViewController.init(nibName: NCConnectedUsersViewController.className, bundle: nil)
        let network = NCNetworkManager.shared
        viewController.model = NCConnectedUsersModel(coordinator: self, network: network, startDate: startDate, endDate: endDate)
        pushViewController(viewController)
    }
    
    func openVisitorsCharts(with startDate: String?, endDate: String?) {
        let viewController = NCVisitorsViewController.init(nibName: NCVisitorsViewController.className, bundle: nil)
        let network = NCNetworkManager.shared
        viewController.model = NCVisitorsModel(coordinator: self, network: network, startDate: startDate, endDate: endDate)
        pushViewController(viewController)
    }
}
