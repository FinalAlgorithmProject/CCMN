//
//  ApplicationConstants.swift
//  CCMN
//
//  Created by Vitalii Poltavets on 2/24/19.
//  Copyright © 2019 unit. All rights reserved.
//

import UIKit

struct NCApplicationConstants {
    
    private init() { }
    
    // Endpoint credentials
    static let cmxURLString = "https://cisco-cmx.unit.ua"
    static let cmxUsername = "RO"
    static let cmxPassword = "just4reading"
    
    static let presenceURLString = "https://cisco-presence.unit.ua"
    static let presenceUsername = "RO"
    static let presencePassword = "Passw0rd"
    
    private static let fontMediumName = "FiraSans-Medium"
    private static let fontRegularName = "FiraSans-Regular"
    
    static let medium21 = UIFont(name: fontMediumName, size: 21.0) ?? UIFont.systemFont(ofSize: 21.0, weight: .medium)
    static let medium17 = UIFont(name: fontMediumName, size: 17.0) ?? UIFont.systemFont(ofSize: 17.0, weight: .medium)
    static let medium15 = UIFont(name: fontMediumName, size: 15.0) ?? UIFont.systemFont(ofSize: 15.0, weight: .medium)
    static let medium13 = UIFont(name: fontMediumName, size: 13.0) ?? UIFont.systemFont(ofSize: 13.0, weight: .medium)
    
    static let regular21 = UIFont(name: fontRegularName, size: 21.0) ?? UIFont.systemFont(ofSize: 21.0, weight: .regular)
    static let regular17 = UIFont(name: fontRegularName, size: 17.0) ?? UIFont.systemFont(ofSize: 17.0, weight: .regular)
    static let regular15 = UIFont(name: fontRegularName, size: 15.0) ?? UIFont.systemFont(ofSize: 15.0, weight: .regular)
    static let regular13 = UIFont(name: fontRegularName, size: 13.0) ?? UIFont.systemFont(ofSize: 13.0, weight: .regular)
    
    static let mainBlackColor = UIColor.grafitBlack
    static let mainRedColor = UIColor.mainRedColor
}
