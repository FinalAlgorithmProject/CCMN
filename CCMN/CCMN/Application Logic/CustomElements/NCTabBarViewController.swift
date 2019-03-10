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

    private var tabs = [
        (selectedImage: "home", tag: 0),
        (selectedImage: "stats", tag: 1),
        (selectedImage: "floor", tag: 2),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = UIColor.mainRedColor
    }
    
    func createTabItem(ofType type: TabTypes, with name: String) -> UITabBarItem {
        let defaultImage =  UIImage(named: tabs[type.rawValue].selectedImage)
        
        // TODO: tags is not correct
        let tabItem = UITabBarItem(title: name, image: defaultImage, tag: type.rawValue)
        return tabItem
    }
    
}
