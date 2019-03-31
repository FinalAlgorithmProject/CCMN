//
//  UIColor+Extension.swift
//  CCMN
//
//  Created by Vitalii Poltavets on 3/10/19.
//  Copyright © 2019 unit. All rights reserved.
//

import UIKit

extension CGFloat {
    static var random:CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    
    static func random() -> UIColor {
        return UIColor(red: .random, green: .random, blue: .random, alpha: 1.0)
    }
    
    static var navigationBarBackground: UIColor {
        return UIColor(red:0.97, green:0.97, blue:0.97, alpha:0.8)
    }

    static var toastBackground: UIColor {
        return UIColor(red: 216.0 / 255.0, green: 213.0 / 255.0, blue: 213.0 / 255.0, alpha: 0.9)
    }
    
    static var successGreenColor: UIColor {
        return UIColor(red:0.30, green:0.85, blue:0.39, alpha:1.0)
    }
    
    static var warningOrangeColor: UIColor {
        return UIColor(red:1.00, green:0.80, blue:0.00, alpha:1.0)
    }
    
    static var warningRedColor: UIColor {
        return UIColor(red:0.91, green:0.35, blue:0.39, alpha:0.9)
    }

}
