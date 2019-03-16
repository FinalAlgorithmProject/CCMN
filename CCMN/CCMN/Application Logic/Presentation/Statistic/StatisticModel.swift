//
//  StatisticModel.swift
//  CCMN
//
//  Created by Vitalii Poltavets on 3/10/19.
//  Copyright © 2019 unit. All rights reserved.
//

import Foundation

final class StatisticModel {
    
    let network: NCNetworkManager
    
    init(network: NCNetworkManager) {
        self.network = network
    }
    
    func repeatedVisitors() {
        network.repeatedVisitorsForSpecificDate(NCStatisticDateEntity(date: "2019-03-15")) { result in
            guard let stats = result else { return }
            let sortedKeysAndValues = Array(stats).sorted { Int($0.key)! < Int($1.key)! }
            dump(sortedKeysAndValues)
        }
    }
    
}
