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
    @IBOutlet weak var ciscoIconImage: UIImageView!
    
    var model: HomeModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initNavigation()
        
        UIView.animate(withDuration: 1) {
            let degrees: Float = 250
            let radians = CGFloat(degrees * Float.pi / 180)
            self.ciscoIconImage.transform = CGAffineTransform(scaleX: 3, y: 3).rotated(by: radians)
            self.ciscoIconImage.alpha = 0
        }
    
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
        showToastLabel(with: "Succefully refreshed!", backgroundColor: UIColor.successToastBackground)
    }

}

extension HomeViewController: Toastable {
    
}
