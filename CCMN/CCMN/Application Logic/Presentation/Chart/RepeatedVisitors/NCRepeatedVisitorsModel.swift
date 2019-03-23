//
//  NCRepeatedVisitorsModel.swift
//  CCMN
//
//  Created by Vitalii Poltavets on 3/17/19.
//  Copyright © 2019 unit. All rights reserved.
//

import Foundation
import Charts

final class NCRepeatedVisitorsModel {
    
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
    
    func repeatedVisitors(completion: @escaping () -> Void) {
        if endDate == nil {
            repeatedVisitorsForDate(completion: completion)
        } else {
            repeatedVisitorsInRange(completion: completion)
        }
    }
    
    private func repeatedVisitorsForDate(completion: @escaping () -> Void) {
        let model = NCStatisticDateEntity(date: startDate)
        network.repeatedVisitorsForSpecificDate(model) { [weak self] result in
            guard let `self` = self, let data = result else { completion(); return }
            self.fillDataSource(with: data, completion: completion)
        }
    }
    
    private func repeatedVisitorsInRange(completion: @escaping () -> Void) {
        let model = NCStatisticRangeEntity(startDate: startDate, endDate: endDate!) // safe
        network.repeatedVisitorsInRange(model: model) { [weak self] result in
            guard let `self` = self, let data = result else { completion(); return }
            self.fillDataSource(with: data, completion: completion)
        }
    }
    
    // This need to be refactored!!!
    private func fillDataSource(with data: [String: NCRepeatedVisitorsStatisticEntity], completion: @escaping () -> Void) {
        let sortedArray = Array(data).sorted { lhs, rhs in
            if let firstHour = Int(lhs.key), let secondHour = Int(rhs.key) {
                return firstHour < secondHour
            }
            return lhs.key < rhs.key
        }
        let allKeys = sortedArray.map { $0.key }
        
        if endDate != nil {
            self.units = sortedArray
                .map { dateFormatter.string(from: formatter.date(from: $0.key)!) }
                .flatMap { Int($0) }
        } else {
            self.units = sortedArray.map { Int($0.key)! }
        }

        self.values = self.units.indices.map { Double(data[allKeys[$0]]!.daily) }
        let dailyMaxValue = self.values.max() ?? 0
        let dailyChartData = self.createChartDataSet(label: "Daily Repeated Visitors",
                                                     color: UIColor.greenChartColor)
        
        self.values = self.units.indices.map { Double(data[allKeys[$0]]!.weekly) }
        let weeklyMaxValue = self.values.max() ?? 0
        let weeklyChartData = self.createChartDataSet(label: "Weekly Repeated Visitors",
                                                      color: UIColor.blueChartColor)
        
        self.values = self.units.indices.map { Double(data[allKeys[$0]]!.occasional) }
        let occasionalMaxValue = self.values.max() ?? 0
        let occasionalChartData = self.createChartDataSet(label: "Occasional Repeated Visitors",
                                                          color: UIColor.yellowChartColor)
        
        self.values = self.units.indices.map { Double(data[allKeys[$0]]!.firstTime) }
        let firstTimeMaxValue = self.values.max() ?? 0
        let firstTimeChartData = self.createChartDataSet(label: "First Time Repeated Visitors",
                                                         color: UIColor.orangeChartColor)
        
        self.values = self.units.indices.map { Double(data[allKeys[$0]]!.firstTime) }
        let yesterdayMaxValue = self.values.max() ?? 0
        let yesterdayChartData = self.createChartDataSet(label: "Yesterday Repeated Visitors",
                                                         color: UIColor.mainRedColor)
        
        self.dataSource.append(ChartData(data: dailyChartData, maxValue: dailyMaxValue + 5))
        self.dataSource.append(ChartData(data: weeklyChartData, maxValue: weeklyMaxValue + 5))
        self.dataSource.append(ChartData(data: occasionalChartData, maxValue: occasionalMaxValue + 5))
        self.dataSource.append(ChartData(data: firstTimeChartData, maxValue: firstTimeMaxValue + 5))
        self.dataSource.append(ChartData(data: yesterdayChartData, maxValue: yesterdayMaxValue + 5))
        completion()
    }
    
    private func createChartDataSet(label: String, color: UIColor) -> BarChartData? {
        if self.values.isEmpty { return nil }
        
        var dataEntries: [BarChartDataEntry] = []
        
        for element in self.doubleHoursValue.indices {
            let dataEntry = BarChartDataEntry(x: self.doubleHoursValue[element], y: self.values[element])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: label)
        chartDataSet.colors = [color]
        chartDataSet.valueFormatter = DefaultValueFormatter(formatter: NumberFormatter())
        
        return BarChartData(dataSet: chartDataSet)
    }
    
}
