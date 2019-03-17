//
//  AppDelegate.swift
//  CCMN
//
//  Created by Vitalii Poltavets on 2/24/19.
//  Copyright © 2019 unit. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var appCoordinator: NCAppCoordinator!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        appCoordinator = NCAppCoordinator()
        
        if !NCNetworkManager.isHostReachable {
            appCoordinator.tabBarRoot(campusInfo: nil)
        } else {
            appCoordinator.loadingScreenRoot()
            self.madeRequests { result in
                self.appCoordinator.tabBarRoot(campusInfo: result)
            }
        }
        
        return true
    }
    
    private func madeRequests(whenFinish completion: @escaping (NCCampusEntity?) -> Void) {
        let group = DispatchGroup()
        var campusInfo: NCCampusEntity?
        
        group.enter()
        NCNetworkManager.shared.siteId { group.leave() }
        
        group.enter()
        NCNetworkManager.shared.campusInformation { result in
            campusInfo = result
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.main) {
            completion(campusInfo)
        }
    }
    
    

}

