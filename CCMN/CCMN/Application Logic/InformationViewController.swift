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
    
    @IBOutlet weak var firstFloorName: UILabel!
    @IBOutlet weak var secondFloorName: UILabel!
    @IBOutlet weak var thirdFloorName: UILabel!
    
    var model = InformationModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Tested requests
        model.getOnlineUsers { count in
            self.devicesOnline.text = "Now online: \(count)"
        }
        
        model.getTodayVisitors { count in
            self.todayVisitors.text = "Today visitors until now: \(count)"
        }
        
        model.campusInformation { buildingName, totalFloors, floorsNames in
            self.buildingName.text = "Building name: \(buildingName)"
            self.totalFloors.text = "Total floors: \(totalFloors)"
            self.firstFloorName.text = "Floor name: \(floorsNames[0])"
            self.secondFloorName.text = "Floor name: \(floorsNames[1])"
            self.thirdFloorName.text = "Floor name: \(floorsNames[2])"
        }
        
        model.repeatedVisitorsInRange()
        model.repeatedVisitorsForDate()

        model.dwellInRange()
        model.dwellForDate()

        model.passerbyInRange()
        model.passerbyForDate()
    }

}

