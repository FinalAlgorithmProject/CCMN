//
//  HomeCoordinator.swift
//  CCMN
//
//  Created by Vitalii Poltavets on 3/10/19.
//  Copyright © 2019 unit. All rights reserved.
//

import Foundation

class NCHomeCoordinator: NCBaseCoordinator {
    
    func homeViewController() -> HomeViewController {
        let viewController = HomeViewController.init(nibName: HomeViewController.className, bundle: nil)
        return viewController
    }
    
}
