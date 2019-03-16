//
//  HomeViewController.swift
//  CCMN
//
//  Created by Vitalii Poltavets on 3/10/19.
//  Copyright © 2019 unit. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var totalDeviceConnectedLabel: UILabel!
    @IBOutlet weak var todayVisitorsLabel: UILabel!
    
    var model: HomeModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initNavigation()
    
        model.devicesConnected { count in
            self.totalDeviceConnectedLabel!.text = "Now connected: \(count)"
            
        }
        model.todayVisitors { count in
            
            self.todayVisitorsLabel!.text = "Today visitors: \(count)"
        }
    }
    
    func initNavigation() {
        navigationItem.title = "\(model.buildingName)"
        
        let item = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadData))
        navigationItem.rightBarButtonItem = item
    }
    
    @objc func reloadData() {
        model.refreshUserData()
        showToastLabel(with: "Succefully refreshed! Wait ...", backgroundColor: UIColor.successToastBackground)
    }

}

extension HomeViewController: Toastable {
    
}
