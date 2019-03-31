//
//  SelectedUser.swift
//  CCMN
//
//  Created by Vitalii Poltavets on 3/31/19.
//  Copyright © 2019 unit. All rights reserved.
//

import Foundation

final class NCSelectedUser {
    
    static var shared = NCSelectedUser()
    
    var macAddress: String?
    
    private init() { }
}
