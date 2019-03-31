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
    var tabBarController: NCTabBarViewController!
    
    init() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window.backgroundColor = UIColor.white
        self.window.makeKeyAndVisible()
    }
    
    func loadingScreenRoot() {
        let viewController = NCLoadingViewController.init(nibName: NCLoadingViewController.className,
                                                          bundle: nil)
        let fakeTabBar = NCTabBarViewController()
        let fakeNavigation = NCNavigationViewController(rootViewController: viewController)
        fakeTabBar.viewControllers = [fakeNavigation]
        window.rootViewController = fakeTabBar
    }
    
    func tabBarRoot(campusInfo: NCCampusImportantInfo?) {
        tabBarController = NCTabBarViewController()
        
        let homeItem = tabBarController.createTabItem(ofType: .home, with: "Home")
        let statisticItem = tabBarController.createTabItem(ofType: .statistic, with: "Statistic")
        let floorItems = campusInfo?.floorNames.sorted()
            .map { tabBarController.createTabItem(ofType: .floor, with: $0.replacingOccurrences(of: "_", with: " ")) }
        
        let homeTabController = homeTab(withItem: homeItem, campusInfo: campusInfo)
        let statisticTabController = statisticTab(withItem: statisticItem)
        
        /// Creates for each tabbaritem viewcontroller embed in with navigation
        var floorTabController: [UINavigationController] = []
        if let names = campusInfo?.floorNames.sorted() {
            let floorMap: [String: Int] = [names[0]: 147, names[1]: 140, names[2]: 80]
            floorItems?.forEach { floorTabController.append(floorTab(withItem: $0,
                                                                     floorName: $0.title!.replacingOccurrences(of: " ", with: "_"),
                                                                     floorCapacity: floorMap[$0.title!.replacingOccurrences(of: " ", with: "_")]!,
                                                                     campus: campusInfo)) }
        }
        
        var viewControllers = [homeTabController, statisticTabController]
        floorTabController.forEach { viewControllers.append($0) }
        tabBarController.viewControllers = viewControllers
        window.rootViewController = tabBarController
    }

    // MARK: - Private API - Creating navigation for each tabs
    private func homeTab(withItem item: UITabBarItem, campusInfo: NCCampusImportantInfo?) -> UINavigationController {
        let navigationController = NCNavigationViewController()
        let homeCoordinator = NCHomeCoordinator(navigationController: navigationController, appCoordinator: self)
        let viewController = homeCoordinator.homeViewController(campusInfo: campusInfo)
        
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

    private func floorTab(withItem item: UITabBarItem,
                          floorName: String,
                          floorCapacity: Int,
                          campus: NCCampusImportantInfo?) -> UINavigationController {
        let navigationController = NCNavigationViewController()
        let floorCoordinator = NCFloorCoordinator(navigationController: navigationController, appCoordinator: self)
        let viewController = floorCoordinator.floorViewController(with: floorName, floorCapacity: floorCapacity, campusInfo: campus)

        viewController.tabBarItem = item
        navigationController.viewControllers = [viewController]
        return navigationController
    }
}
