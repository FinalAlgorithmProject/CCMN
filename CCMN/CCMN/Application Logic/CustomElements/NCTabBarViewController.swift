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
        (selectedImage: "icHome", tag: 0),
        (selectedImage: "icPay", tag: 1),
        (selectedImage: "icStatements", tag: 2),
        (selectedImage: "icSettings", tag: 3)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
//        tabBar.tintColor = UIColor.mainRedColor
    }
    
    func createTabItem(ofType type: TabTypes, with name: String) -> UITabBarItem {
        var tabItem: UITabBarItem!
        
        let defaultImage =  UIImage(named: tabs[type.rawValue].selectedImage)
        let selectedImage = UIImage(named: tabs[type.rawValue].selectedImage)
        
        tabItem = UITabBarItem(title: name,
                               image: defaultImage?.withRenderingMode(.alwaysOriginal),
                               selectedImage: selectedImage?.withRenderingMode(.alwaysTemplate))
        tabItem.tag = tabs[type.rawValue].tag
        
        print("Created tab with name: \(name)")
//        #warning("Debug")
//        tabItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.init(rawValue: type.rawValue)!, tag: 0)
//        tabItem.title = name
        
        return tabItem
    }
    
}
