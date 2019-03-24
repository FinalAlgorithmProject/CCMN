//
//  NCChartTableViewCell.swift
//  CCMN
//
//  Created by Vitalii Poltavets on 3/17/19.
//  Copyright © 2019 unit. All rights reserved.
//

import UIKit
import Charts

class NCBarChartTableViewCell: UITableViewCell {

    @IBOutlet weak var barChartView: BarChartView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initChartView()
        selectionStyle = .none
    }
    
    func setData(_ data: BarChartData?, maxYValue: Double?) {
        guard let data = data else { return }
        barChartView.data = data
        barChartView.leftAxis.axisMaximum = maxYValue ?? 0
    }
    
    private func initChartView() {
        barChartView.chartDescription?.text = ""
        
        barChartView.rightAxis.enabled = false
        
        barChartView.scaleYEnabled = false
        barChartView.scaleXEnabled = false
        barChartView.pinchZoomEnabled = false
        barChartView.doubleTapToZoomEnabled = false
        
        barChartView.animate(yAxisDuration: 1.5, easingOption: .easeInOutQuart)
        
        let xAxis = barChartView.xAxis
        xAxis.labelPosition = XAxis.LabelPosition.bottom
        xAxis.drawGridLinesEnabled = false
        xAxis.granularity = 1
    }   
}
