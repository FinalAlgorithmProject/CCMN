//
//  NCForecastingViewController.swift
//  CCMN
//
//  Created by Vitalii Poltavets on 3/31/19.
//  Copyright © 2019 unit. All rights reserved.
//

import UIKit
import Charts

class NCForecastingViewController: UIViewController {
    
    @IBOutlet weak var monthBarChartView: BarChartView!
    @IBOutlet weak var weekChartView: BarChartView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var model: NCForecastingModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Number of visitors forecast"
        
        initChartView(weekChartView)
        initChartView(monthBarChartView)
        
        model.chartData { [weak self] week, month in
            guard let `self` = self else { return }
            
            self.weekChartView.data = week.data
            self.weekChartView.rightAxis.axisMaximum = week.maxValue
            
            self.monthBarChartView.data = month.data
            self.monthBarChartView.rightAxis.axisMaximum = month.maxValue
        }
        
    }
    
    private func initChartView(_ chart: BarChartView) {
        chart.chartDescription?.text = ""
        
        chart.rightAxis.enabled = false
        
        chart.scaleYEnabled = false
        chart.scaleXEnabled = false
        chart.pinchZoomEnabled = false
        chart.doubleTapToZoomEnabled = false
        
        chart.animate(yAxisDuration: 1.5, easingOption: .easeInOutQuart)
        
        chart.xAxis.enabled = false
        chart.legend.font = NCApplicationConstants.regular15
        chart.legend.verticalAlignment = .bottom
        chart.legend.horizontalAlignment = .right

    }

}
