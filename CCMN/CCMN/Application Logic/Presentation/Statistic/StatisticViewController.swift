//
//  StatisticViewController.swift
//  CCMN
//
//  Created by Vitalii Poltavets on 3/10/19.
//  Copyright © 2019 unit. All rights reserved.
//

import UIKit

class StatisticViewController: UIViewController {

    var model: StatisticModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Statistic"
        
        model.repeatedVisitors()
    }
}
