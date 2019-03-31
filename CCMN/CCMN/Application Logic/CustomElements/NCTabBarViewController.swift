//
//  NCTabBarViewController.swift
//  CCMN
//
//  Created by Vitalii Poltavets on 3/10/19.
//  Copyright © 2019 unit. All rights reserved.
//

import UIKit

enum TabTypes: Int {
    case home, statistic, floor
}

class NCTabBarViewController: UITabBarController {
    
    private var tabs = ["home", "stats", "floor"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = NCApplicationConstants.mainRedColor
    }
    
    func createTabItem(ofType type: TabTypes, with name: String) -> UITabBarItem {
        let defaultImage =  UIImage(named: tabs[type.rawValue])
        
        tabBarItem.tag += 1
        let currentTag = tabBarItem.tag
        let tabItem = UITabBarItem(title: name, image: defaultImage, tag: currentTag)
        return tabItem
    }
    
}
