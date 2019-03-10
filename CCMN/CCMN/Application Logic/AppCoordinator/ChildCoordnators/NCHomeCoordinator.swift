//
//  HomeCoordinator.swift
//  CCMN
//
//  Created by Vitalii Poltavets on 3/10/19.
//  Copyright © 2019 unit. All rights reserved.
//

import Foundation

class NCHomeCoordinator: NCBaseCoordinator {
    
    func homeViewController(buildingName name: String) -> HomeViewController {
        let viewController = HomeViewController.init(nibName: HomeViewController.className, bundle: nil)
        viewController.model = HomeModel(buildingName: name, network: NCNetworkManager.shared)
        return viewController
    }
    
}
