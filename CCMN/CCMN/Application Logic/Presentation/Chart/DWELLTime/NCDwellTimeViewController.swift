//
//  NCDwellTimeViewController.swift
//  CCMN
//
//  Created by Vitalii Poltavets on 3/17/19.
//  Copyright © 2019 unit. All rights reserved.
//

import UIKit

class NCDwellTimeViewController: UIViewController {

    @IBOutlet weak var chartsTableView: UITableView!
    
    var model: NCDwellTimeModel!
    
    private let identifier = NCBarChartTableViewCell.className
    private let rowHeight: CGFloat = 300
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "DWell Time"
        
        chartsTableView.registerNib(with: identifier)
        chartsTableView.tableFooterView = UIView()
     
        model.dwellTimeStatistic {
            self.chartsTableView.reloadSections(IndexSet(integer: 0), with: .fade)
        }
    }
}

extension NCDwellTimeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
}

extension NCDwellTimeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! NCBarChartTableViewCell
        let data = model.dataSource[indexPath.row]
        cell.setData(data.data, maxYValue: data.maxValue)
        return cell
    } 
}
