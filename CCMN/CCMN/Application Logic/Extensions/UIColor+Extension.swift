//
//  UIColor+Extension.swift
//  CCMN
//
//  Created by Vitalii Poltavets on 3/10/19.
//  Copyright © 2019 unit. All rights reserved.
//

import UIKit

extension UIColor {
    
    static var warningRedColor: UIColor {
        return UIColor(red:0.91, green:0.35, blue:0.39, alpha:1.0)
    }
    
    static var navigationBarBackground: UIColor {
        return UIColor(red:0.97, green:0.97, blue:0.97, alpha:0.8)
    }
    
    /// Main tint color for text, tabbar and baritem butons
    static var grafitBlack: UIColor {
        return UIColor(red:0.25, green:0.25, blue:0.25, alpha:1.0)
    }
    
    /// Tint color
    static var mainRedColor: UIColor {
        return UIColor(red:0.70, green:0.19, blue:0.30, alpha:1.0)
    }
    
    static var toastBackground: UIColor {
        return UIColor(red: 216.0 / 255.0, green: 213.0 / 255.0, blue: 213.0 / 255.0, alpha: 1)
    }
}
