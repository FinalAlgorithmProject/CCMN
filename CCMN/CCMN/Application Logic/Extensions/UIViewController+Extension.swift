//
//  UIViewController+Extension.swift
//  CCMN
//
//  Created by Vitalii Poltavets on 3/10/19.
//  Copyright © 2019 unit. All rights reserved.
//

import UIKit

/// There is more UIViewController extension
/// but its private in Toastable protocol
extension UIViewController {
    /// For device with iOS 10, to get tabBar height
    var tabBarHeight: CGFloat {
        return self.tabBarController?.tabBar.frame.size.height ?? 0
    }
    
    /// For device with iOS 10, to get navigationBar height
    var navigationBarHeight: CGFloat {
        return self.navigationController?.navigationBar.frame.size.height ?? 0
    }
}
