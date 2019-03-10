//
//  MainCoordinator.swift
//  CCMN
//
//  Created by Vitalii Poltavets on 3/10/19.
//  Copyright © 2019 unit. All rights reserved.
//

import UIKit

class NCBaseCoordinator {
    
    let navigationController: UINavigationController
    
    private let appCoordinator: NCAppCoordinator
    
    init(navigationController: UINavigationController, appCoordinator: NCAppCoordinator) {
        self.navigationController = navigationController
        self.appCoordinator = appCoordinator
    }
    
    func pushViewController(_ viewController: UIViewController, animated: Bool = true) {
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    func present(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        let navigation = NCNavigationViewController()
        
        viewController.modalTransitionStyle = .coverVertical
        viewController.modalPresentationStyle = .overFullScreen
        navigation.viewControllers = [viewController]
        navigationController.present(navigation, animated: animated, completion: completion)
    }
    
    func popViewController(animated: Bool = true) {
        navigationController.popViewController(animated: animated)
    }
}
