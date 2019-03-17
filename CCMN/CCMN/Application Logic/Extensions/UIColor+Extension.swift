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
        return UIColor(red:0.91, green:0.35, blue:0.39, alpha:0.9)
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
        return UIColor(red: 216.0 / 255.0, green: 213.0 / 255.0, blue: 213.0 / 255.0, alpha: 0.9)
    }
    
    static var successToastBackground: UIColor {
        return UIColor(red:0.11, green:0.76, blue:0.22, alpha:0.9)
    }
    
    
    // Charts colors
    static var greenChartColor: UIColor {
        return UIColor(red: 104/255, green: 241/255, blue: 175/255, alpha: 1)
    }
    
    static var blueChartColor: UIColor {
        return UIColor(red: 164/255, green: 228/255, blue: 251/255, alpha: 1)
    }
    
    static var yellowChartColor: UIColor {
        return UIColor(red: 242/255, green: 247/255, blue: 158/255, alpha: 1)
    }
    
    static var orangeChartColor: UIColor {
        return UIColor(red: 255/255, green: 102/255, blue: 0/255, alpha: 1)
    }

}
