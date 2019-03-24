//
//  HomeCoordinator.swift
//  CCMN
//
//  Created by Vitalii Poltavets on 3/10/19.
//  Copyright © 2019 unit. All rights reserved.
//

import Foundation

class NCHomeCoordinator: NCBaseCoordinator {
    
    func homeViewController(campusInfo: NCCampusImportantInfo?) -> HomeViewController {
        let viewController = HomeViewController.init(nibName: HomeViewController.className, bundle: nil)
        let network = NCNetworkManager.shared
        viewController.model = HomeModel(coordinator: self, campusInfo: campusInfo, network: network)
        return viewController
    }
    
}
