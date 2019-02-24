//
//  NetworkServiceProtocol.swift
//  CCMN
//
//  Created by Vitalii Poltavets on 2/24/19.
//  Copyright © 2019 unit. All rights reserved.
//

import Foundation

protocol NetworkManagerProtocol {
    func getAesUID(completion: @escaping () -> Void)
    func usersOnline(completion: @escaping (Int) -> Void) 
}
