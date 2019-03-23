//
//  NCConnectedUsersViewController.swift
//  CCMN
//
//  Created by Vitalii Poltavets on 3/23/19.
//  Copyright © 2019 unit. All rights reserved.
//

import UIKit

class NCConnectedUsersViewController: UIViewController {

    @IBOutlet weak var chartsTableView: UITableView!
    
    var model: NCConnectedUsersModel!
    
    private let identifier = NCBarChartTableViewCell.className
    private let rowHeight: CGFloat = 300
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Connected Users"
        
        chartsTableView.registerNib(with: identifier)
        chartsTableView.tableFooterView = UIView()
        
        model.connectedUsersStatistic {
            self.chartsTableView.reloadSections(IndexSet(integer: 0), with: .fade)
        }
    }
}

extension NCConnectedUsersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
}

extension NCConnectedUsersViewController: UITableViewDataSource {
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
