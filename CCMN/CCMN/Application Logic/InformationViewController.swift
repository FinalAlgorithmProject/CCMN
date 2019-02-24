//
//  ViewController.swift
//  CCMN
//
//  Created by Vitalii Poltavets on 2/24/19.
//  Copyright © 2019 unit. All rights reserved.
//

import UIKit

class InformationViewController: UIViewController {

    @IBOutlet weak var devicesOnline: UILabel!
    @IBOutlet weak var todayVisitors: UILabel!
    @IBOutlet weak var buildingName: UILabel!
    @IBOutlet weak var totalFloors: UILabel!
    
    
    var model = InformationModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.getOnlineUsers { count in
            self.devicesOnline.text = "Now online: \(count)"
        }
        
        model.getTodayVisitors { count in
            self.todayVisitors.text = "Today visitors until now: \(count)"
        }
        
        model.campusInformation { buildingName, totalFloors in
            self.buildingName.text = "Building name: \(buildingName)"
            self.totalFloors.text = "Total floors: \(totalFloors)"
        }
    }

}

