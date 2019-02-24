//
//  NetworkServiceProtocol.swift
//  CCMN
//
//  Created by Vitalii Poltavets on 2/24/19.
//  Copyright © 2019 unit. All rights reserved.
//

import Foundation

protocol NetworkManagerProtocol {
    func siteId(completion: @escaping () -> Void)
    func usersOnline(completion: @escaping (Int) -> Void)
    func todayVisitors(completion: @escaping (Int) -> Void)
    func campusInformation(completion: @escaping (CampusEntity?) -> Void)
}
