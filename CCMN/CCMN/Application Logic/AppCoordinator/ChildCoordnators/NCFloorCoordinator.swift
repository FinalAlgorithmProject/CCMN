//
//  NCFloorCoordinator.swift
//  CCMN
//
//  Created by Vitalii Poltavets on 3/10/19.
//  Copyright © 2019 unit. All rights reserved.
//

import Foundation

class NCFloorCoordinator: NCBaseCoordinator {
    
    func floorViewController(with name: String, campusInfo: NCCampusImportantInfo?) -> FloorViewController {
        let viewController = FloorViewController.init(nibName: FloorViewController.className, bundle: nil)
        let network = NCNetworkManager.shared
        viewController.model = FloorModel(network: network, floorName: name, campusInfo: campusInfo)
        return viewController
    }
    
}
