//
//  NCRepeatedVisitorsChartViewController.swift
//  CCMN
//
//  Created by Vitalii Poltavets on 3/17/19.
//  Copyright © 2019 unit. All rights reserved.
//

import UIKit
import Charts

class NCRepeatedVisitorsChartViewController: UIViewController {
    
    @IBOutlet weak var chartsTableView: UITableView!
    
    var model: NCRepeatedVisitorsModel!
    private let identifier = NCChartTableViewCell.className
    
    private let rowHeight: CGFloat = 300
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Repeated Visitors"
        
        chartsTableView.registerNib(with: identifier)
        chartsTableView.tableFooterView = UIView()
        
        model.repeatedVisitors {
            self.chartsTableView.reloadSections(IndexSet(integer: 0), with: .fade)
        }
    }
}


extension NCRepeatedVisitorsChartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
}

extension NCRepeatedVisitorsChartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! NCChartTableViewCell
        let data = model.dataSource[indexPath.row]
        cell.setData(data: data.data, maxYValue: data.maxValue)
        return cell
    }
    
    
}

