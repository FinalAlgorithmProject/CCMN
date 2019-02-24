//
//  UserDefaults.swift
//  CCMN
//
//  Created by Vitalii Poltavets on 2/24/19.
//  Copyright © 2019 unit. All rights reserved.
//

import Foundation

private struct DefaultsKeys {
    static let siteId = "siteId"
}

struct UserDefaultsService {

    static var siteId: Int {
        set { save(newValue, forKey: DefaultsKeys.siteId) }
        get { return intValue(forKey: DefaultsKeys.siteId) }
    }
    
    // MARK: Private API
    private static func save<T>(_ value: T, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    private static func intValue(forKey key: String) -> Int {
        return UserDefaults.standard.integer(forKey: key)
    }
    
    private static func stringValue(forKey key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
}
