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
    
    private var units: [Int] = [] // hours or dates
    private var values: [Double] = []
    
    private var doubleHoursValue: [Double] {
        return self.units.map { Double($0) }
    }
    
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
        self.startDate = startDate ?? formatter.string(from: Date())
        self.endDate = endDate
    }
    
    func dwellTimeStatistic(completion: @escaping () -> Void) {
        if endDate == nil {
            dwellForSpecificDate(completion: completion)
        } else {
            dwellInRange(completion: completion)
        }
    }
    
    private func dwellForSpecificDate(completion: @escaping () -> Void) {
        let model = NCStatisticDateEntity(date: startDate)
        network.dwellForSpecificDate(model) { [weak self] result in
            guard let `self` = self, let data = result else { completion(); return }
            self.fillDataSource(with: data, completion: completion)
        }
    }
    
    private func dwellInRange(completion: @escaping () -> Void) {
        let model = NCStatisticRangeEntity(startDate: startDate, endDate: endDate!) // safe
        network.dwellInRange(model: model) { [weak self] result in
            guard let `self` = self, let data = result else { completion(); return }
            self.fillDataSource(with: data, completion: completion)
        }
    }
    
    private func fillDataSource(with data: [String: NCDWELLStatisticEntity], completion: @escaping () -> Void) {
        let sortedArray = Array(data).sorted { lhs, rhs in
            if let firstHour = Int(lhs.key), let secondHour = Int(rhs.key) {
                return firstHour < secondHour
            }
            return lhs.key < rhs.key
        }
        let allKeys = sortedArray.map { $0.key }
        
        print(allKeys)
        if endDate != nil {
            self.units = sortedArray
                .map { dateFormatter.string(from: formatter.date(from: $0.key)!) }
                .flatMap { Int($0) }
        } else {
            self.units = sortedArray.map { Int($0.key)! }
        }
        self.values = self.units.indices.map { Double(data[allKeys[$0]]!.eightPlusHours) }
        let eightPlusMaxValue = self.values.max() ?? 0
        let eightPlusChartData = self.createChartDataSet(label: "8+ Hours", color: ChartColorTemplates.material())
        
        self.values = self.units.indices.map { Double(data[allKeys[$0]]!.fiveToEightHours) }
        let fiveToEightHoursMaxValue = self.values.max() ?? 0
        let fiveToEightHoursChartData = self.createChartDataSet(label: "5 - 8 Hours", color: ChartColorTemplates.joyful())
        
        self.values = self.units.indices.map { Double(data[allKeys[$0]]!.oneToFiveHours) }
        let oneToFiveHoursMaxValue = self.values.max() ?? 0
        let oneToFiveHoursChartData = self.createChartDataSet(label: "5 - 1 Hours", color: ChartColorTemplates.colorful())
        
        self.values = self.units.indices.map { Double(data[allKeys[$0]]!.thirtyToSixtyMinutes) }
        let thirtyToSixtyMinutesMaxValue = self.values.max() ?? 0
        let thirtyToSixtyMinutesChartData = self.createChartDataSet(label: "30 - 6 Minutes", color: ChartColorTemplates.vordiplom())
        
        self.values = self.units.indices.map { Double(data[allKeys[$0]]!.fiveToThirtyMinutes) }
        let fiveToThirtyMinutesMaxValue = self.values.max() ?? 0
        let fiveToThirtyMinutesChartData = self.createChartDataSet(label: "5 - 30 Minutes", color: ChartColorTemplates.pastel())
        
        self.dataSource.append(ChartData(data: eightPlusChartData, maxValue: eightPlusMaxValue + 5))
        self.dataSource.append(ChartData(data: fiveToEightHoursChartData, maxValue: fiveToEightHoursMaxValue + 5))
        self.dataSource.append(ChartData(data: oneToFiveHoursChartData, maxValue: oneToFiveHoursMaxValue + 5))
        self.dataSource.append(ChartData(data: thirtyToSixtyMinutesChartData, maxValue: thirtyToSixtyMinutesMaxValue + 5))
        self.dataSource.append(ChartData(data: fiveToThirtyMinutesChartData, maxValue: fiveToThirtyMinutesMaxValue + 5))
        self.dataSource.forEach { $0.0?.setValueFont(NCApplicationConstants.regular13) }
        completion()
    }

    private func createChartDataSet(label: String, color: [UIColor]) -> BarChartData? {
        if self.values.isEmpty { return nil }
        
        var dataEntries: [BarChartDataEntry] = []
        
        for element in self.doubleHoursValue.indices {
            let dataEntry = BarChartDataEntry(x: self.doubleHoursValue[element], y: self.values[element])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: label)
        chartDataSet.colors = [color.first!]
        chartDataSet.valueFormatter = DefaultValueFormatter(formatter: NumberFormatter())
        
        return BarChartData(dataSet: chartDataSet)
    }
    
}
