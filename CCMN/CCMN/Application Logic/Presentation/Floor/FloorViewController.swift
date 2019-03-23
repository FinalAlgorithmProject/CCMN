//
//  FloorViewController.swift
//  CCMN
//
//  Created by Vitalii Poltavets on 3/10/19.
//  Copyright © 2019 unit. All rights reserved.
//

import UIKit

class FloorViewController: UIViewController {

    @IBOutlet weak var floorImageView: UIImageView!
    
    var model: FloorModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Floor Information"
        
        model.getImage { image in
            self.floorImageView.image = image
        }
    }


}
