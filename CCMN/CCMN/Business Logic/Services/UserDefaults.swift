//
//  UserDefaults.swift
//  CCMN
//
//  Created by Vitalii Poltavets on 2/24/19.
//  Copyright © 2019 unit. All rights reserved.
//

import Foundation

private struct DefaultsKeys {
    static let aesUID = "aesUID"
}

struct UserDefaultsService {

    static var aesUID: String? {
        set { save(newValue, forKey: DefaultsKeys.aesUID) }
        get { return stringValue(forKey: DefaultsKeys.aesUID) }
    }
    
    // MARK: Private API
    private static func save<T>(_ value: T, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    private static func stringValue(forKey key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
}
