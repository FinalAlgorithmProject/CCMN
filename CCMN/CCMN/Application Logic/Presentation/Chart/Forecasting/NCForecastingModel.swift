//
//  NCForecastingModel.swift
//  CCMN
//
//  Created by Vitalii Poltavets on 3/31/19.
//  Copyright © 2019 unit. All rights reserved.
//

import Foundation
import Charts

final class NCForecastingModel {
    
    typealias ChartData = (data: BarChartData?, maxValue: Double)
    
    private let network: NCNetworkManager
    private let numberOfWeeksInYear = 52
    private let numberOfMonthInYear = 12
    
    private lazy var formatterFromString: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    private lazy var formatterToDayName: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "EEEE"
        return formatter
    }()
    
    private lazy var formatterToMonthName: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "MMMM"
        return formatter
    }()
    
    init(network: NCNetworkManager) {
        self.network = network
    }
    
    func chartData(completion: @escaping (_ weekChart: ChartData, _ monthChart: ChartData) -> Void) {
        let model = NCStatisticRangeEntity(startDate: "2018-01-01", endDate: "2018-12-31")
        network.visitorsInRange(model: model) { [weak self] result in
            guard let `self` = self, let stats = result else { return }
            
            let sortedArray = Array(stats).sorted { $0.key < $1.key }

            // Days part ---------------------------------
            let totalWeekDaysVisitors = sortedArray.reduce([String: Int](), self.weekBlock)
            let averageDayVisitors = totalWeekDaysVisitors.map { ($0.key, $0.value / self.numberOfWeeksInYear) }.sorted { $0.1 > $1.1 }
            var days: [Int] = []
            for i in 0..<7 { days.append(i) }
            
            var weekEntries: [BarChartDataEntry] = []
            for i in averageDayVisitors.indices {
                let element = averageDayVisitors[i]
                let x = Double(days[i])
                let y = Double(element.1)
                weekEntries.append(BarChartDataEntry(x: x, y: y))
            }
            
            var weekSets: [BarChartDataSet] = []
            for day in days {
                let set = self.createSet(with: weekEntries[day], label: averageDayVisitors[day].0)
                weekSets.append(set)
            }
            // ---------------------------------------------
            
            // Month part ---------------------------------
            let totalMonthVisitors = sortedArray.reduce([String: Int](), self.monthBlock)
            let averageMonthVisitors = totalMonthVisitors.map { ($0.key, $0.value / self.numberOfMonthInYear) }.sorted { $0.1 > $1.1 }
            var months: [Int] = []
            for i in 0..<self.numberOfMonthInYear { months.append(i) }
            
            var monthEntries: [BarChartDataEntry] = []
            for i in averageMonthVisitors.indices {
                let element = averageMonthVisitors[i]
                let x = Double(months[i])
                let y = Double(element.1)
                monthEntries.append(BarChartDataEntry(x: x, y: y))
            }
            
            var monthSets: [BarChartDataSet] = []
            for month in months {
                let set = self.createSet(with: monthEntries[month], label: averageMonthVisitors[month].0)
                monthSets.append(set)
            }
            // ---------------------------------------------
            
            let weekData = BarChartData(dataSets: weekSets)
            weekData.setValueFont(NCApplicationConstants.regular13)
            let maxDayValue = averageDayVisitors.max { $0.1 < $1.1 }?.1
            let weekChart = ChartData(data: weekData, maxValue: Double(maxDayValue ?? 1000))
            
            let monthData = BarChartData(dataSets: monthSets)
            monthData.setValueFont(NCApplicationConstants.regular13)
            let maxMonthValue = averageMonthVisitors.max { $0.1 < $1.1 }?.1
            let monthChart = ChartData(data: monthData, maxValue: Double(maxMonthValue ?? 10000))
            
            completion(weekChart, monthChart)
        }
    }
    
    
    private func weekBlock(stackedDictinary: [String: Int], currentDictinary: (key: String, value: Int)) -> [String: Int] {
        var dictinary = stackedDictinary
        let dateFromString = self.formatterFromString.date(from: currentDictinary.key)!
        let weekName = self.formatterToDayName.string(from: dateFromString)
        if let value = dictinary[weekName] {
            dictinary[weekName] = value + currentDictinary.value
        } else {
            dictinary[weekName] = currentDictinary.value
        }
        return dictinary
    }
    
    private func monthBlock(stackedDictinary: [String: Int], currentDictinary: (key: String, value: Int)) -> [String: Int] {
        var dictinary = stackedDictinary
        let dateFromString = self.formatterFromString.date(from: currentDictinary.key)!
        let monthName = self.formatterToMonthName.string(from: dateFromString)
        if let value = dictinary[monthName] {
            dictinary[monthName] = value + currentDictinary.value
        } else {
            dictinary[monthName] = currentDictinary.value
        }
        return dictinary
    }
    
    private func createSet(with entry: BarChartDataEntry, label: String) -> BarChartDataSet {
        let set = BarChartDataSet(values: [entry], label: label)
        set.colors = [UIColor.random()]
        return set
    }
}
















