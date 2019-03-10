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
        return viewController
    }
    
}
