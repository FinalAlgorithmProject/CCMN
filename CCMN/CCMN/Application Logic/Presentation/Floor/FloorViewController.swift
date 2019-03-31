//
//  FloorViewController.swift
//  CCMN
//
//  Created by Vitalii Poltavets on 3/10/19.
//  Copyright © 2019 unit. All rights reserved.
//

import UIKit
import Charts

class FloorViewController: UIViewController {

    @IBOutlet weak var floorImageView: UIImageView!
    @IBOutlet weak var usersCountLabel: UILabel!
    @IBOutlet weak var floorLoadingLabel: UILabel!
    
    var model: FloorModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initNavigation()
        
        model.getImage { image in
            self.floorImageView.image = image
        }
        
        model.clientsInfo { [weak self] studentsPoints, floorLoading in
            guard let `self` = self else { return }
            
            switch floorLoading {
            case .high(let students):
                self.floorLoadingLabel.text = "High"
                self.floorLoadingLabel.textColor = UIColor.warningRedColor
                self.usersCountLabel.text = "Students on selected floor: \(students)"
            case .medium(let students):
                self.floorLoadingLabel.text = "Medium"
                self.floorLoadingLabel.textColor = UIColor.warningOrangeColor
                self.usersCountLabel.text = "Students on selected floor: \(students)"
            case .low(let students):
                self.floorLoadingLabel.text = "Low"
                self.floorLoadingLabel.textColor = UIColor.successGreenColor
                self.usersCountLabel.text = "Students on selected floor: \(students)"
            }
            
            self.floorImageView.subviews.forEach { $0.removeFromSuperview() }
            for studentInfo in studentsPoints {
                let frame = CGRect(origin: studentInfo.value, size: CGSize(width: 10, height: 10))
                let studentDotView = UIView(frame: frame)
                studentDotView.layer.cornerRadius = 5
                studentDotView.backgroundColor = .red
                studentDotView.tag = studentInfo.key
                self.floorImageView.addSubview(studentDotView)
            }
        }
    }
    
    private func initNavigation() {
        navigationItem.title = "Floor Information"
        let refreshItem = UIBarButtonItem(barButtonSystemItem: .refresh,
                                          target: self,
                                          action: #selector(reloadData))
        navigationItem.rightBarButtonItem = refreshItem
    }
    
    @objc private func reloadData() {
        model.reloadMap()
        showToastLabel(with: "Succefully refreshed!",
                       backgroundColor: UIColor.successGreenColor)
    }
}

extension FloorViewController: Toastable { }
