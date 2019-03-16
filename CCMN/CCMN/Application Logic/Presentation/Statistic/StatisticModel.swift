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
    
    private var hours: [Int] = []
    
    init(network: NCNetworkManager) {
        self.network = network
    }
    
    func repeatedVisitors(completion: @escaping () -> Void) {
        network.repeatedVisitorsForSpecificDate(NCStatisticDateEntity(date: "2019-03-15")) { [weak self] result in
            guard let `self` = self, let stats = result else { return }
            let sortedArray = Array(stats).sorted { Int($0.key)! < Int($1.key)! }
            self.hours = sortedArray.map { Int($0.key)! }
            print(self.hours)
            completion()
        }
    }
    
}
