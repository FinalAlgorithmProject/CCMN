//
//  AppCoordinator.swift
//  CCMN
//
//  Created by Vitalii Poltavets on 3/10/19.
//  Copyright © 2019 unit. All rights reserved.
//

import UIKit

final class NCAppCoordinator {
    
    var window: UIWindow
    
    init() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window.backgroundColor = UIColor.white
        self.window.makeKeyAndVisible()
    }
    
    func loadingScreenRoot() {
        let viewController = NCLoadingViewController.init(nibName: NCLoadingViewController.className,
                                                          bundle: nil)
        window.rootViewController = viewController
    }
    
    func tabBarRoot(campusInfo: NCCampusEntity?) {
        let tabBarController = NCTabBarViewController()
        
        let homeItem = tabBarController.createTabItem(ofType: .home, with: "Home")
        let statisticItem = tabBarController.createTabItem(ofType: .statistic, with: "Statistic")
        
        let buldingName = campusInfo?.campusCounts.first?.buildingCounts.first?.buildingName ?? "Unknown"
        /// Creates for each floor tabbaritem
        let floorsNames = campusInfo?.campusCounts.first?.buildingCounts.first?.floorCounts.map { $0.floorName }.sorted() ?? []
        var floorItems: [UITabBarItem] = []
        
        /// it can be shorter, but who cares?
        for floorName in floorsNames {
            let freshTab = tabBarController.createTabItem(ofType: .floor, with: floorName)
            floorItems.append(freshTab)
        }
        
        let homeTabController = homeTab(withItem: homeItem, buldingName: buldingName)
        let statisticTabController = statisticTab(withItem: statisticItem)
        
        /// Creates for each tabbaritem viewcontroller embed in with navigation
        var floorTabController: [UINavigationController] = []
        floorItems.forEach { floorTabController.append(floorTab(withItem: $0)) }
        
        var viewControllers = [homeTabController, statisticTabController]
        floorTabController.forEach { viewControllers.append($0) }
        tabBarController.viewControllers = viewControllers
        window.rootViewController = tabBarController
    }
    
    // MARK: - Private API - Creating navigation for each tabs
    private func homeTab(withItem item: UITabBarItem, buldingName: String) -> UINavigationController {
        let navigationController = NCNavigationViewController()
        let homeCoordinator = NCHomeCoordinator(navigationController: navigationController, appCoordinator: self)
        let viewController = homeCoordinator.homeViewController(buildingName: buldingName)
        
        viewController.tabBarItem = item
        navigationController.viewControllers = [viewController]
        return navigationController
    }
    
    private func statisticTab(withItem item: UITabBarItem) -> UINavigationController {
        let navigationController = NCNavigationViewController()
        let statisticCoordinator = NCStatisticCoordinator(navigationController: navigationController, appCoordinator: self)
        let viewController = statisticCoordinator.statisticViewController()

        viewController.tabBarItem = item
        navigationController.viewControllers = [viewController]
        return navigationController
    }

    private func floorTab(withItem item: UITabBarItem) -> UINavigationController {
        let navigationController = NCNavigationViewController()
        let floorCoordinator = NCFloorCoordinator(navigationController: navigationController, appCoordinator: self)
        let viewController = floorCoordinator.floorViewController()

        viewController.tabBarItem = item
        navigationController.viewControllers = [viewController]
        return navigationController
    }
}
