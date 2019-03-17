//
//  NCDwellTime.swift
//  CCMN
//
//  Created by Vitalii Poltavets on 3/17/19.
//  Copyright © 2019 unit. All rights reserved.
//

import Foundation
import Charts

final class NCDwellTimeModel {
    
    typealias ChartData = (data: BarChartData?, maxValue: Double?)
    
    private let coordinator: NCStatisticCoordinator
    private let network: NCNetworkManager
    
    private var startDate: String!
    private var endDate: String?
    
    private lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd"
        return formatter
    }()
    
    var dataSource: [ChartData] = []
    
    init(coordinator: NCStatisticCoordinator,
         network: NCNetworkManager,
         startDate: String?,
         endDate: String?) {
        
        self.coordinator = coordinator
        self.network = network
        self.startDate = startDate
        self.endDate = endDate
    }
    
    func dwellTimeStatistic(completion: @escaping () -> Void) {
        if startDate == nil {
            startDate = formatter.string(from: Date())
        }
        if endDate == nil {
            repeatedVisitorsForDate(completion: completion)
        } else {
            repeatedVisitorsInRange(completion: completion)
        }
    }
    
    private func repeatedVisitorsForDate(completion: @escaping () -> Void) {
        let model = NCStatisticDateEntity(date: startDate)
        network.dwellForSpecificDate(model) { [weak self] result in
            guard let `self` = self, let data = result else { completion(); return }
            self.fillDataSource(with: data, completion: completion)
        }
    }
    
    private func repeatedVisitorsInRange(completion: @escaping () -> Void) {
        let model = NCStatisticRangeEntity(startDate: startDate, endDate: endDate!) // safe
        network.dwellInRange(model: model) { [weak self] result in
            guard let `self` = self, let data = result else { completion(); return }
            self.fillDataSource(with: data, completion: completion)
        }
    }
    
    private func fillDataSource(with data: [String: NCDWELLStatisticEntity], completion: @escaping () -> Void) {
        print(data)
    }

    
}
