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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        addStudentsDots { [weak self] in
            let view = self?.floorImageView.subviews
                .first { $0.tag == NCSelectedUser.shared.macAddress?.hashValue ?? -1 }
            
            UIView.animate(withDuration: 1, animations: {
                view?.transform = CGAffineTransform(scaleX: 6, y: 6)
                view?.backgroundColor = UIColor.successGreenColor
            }, completion: { _ in
                UIView.animate(withDuration: 1, animations: {
                    view?.transform = .identity
                    view?.backgroundColor = UIColor.warningRedColor
                })
            })
            NCSelectedUser.shared.macAddress = nil
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
        addStudentsDots { [weak self] in
            self?.showToastLabel(with: "Succefully refreshed!",
                                 backgroundColor: UIColor.successGreenColor)
        }
    }
    
    private func addStudentsDots(_ completion: @escaping () -> Void) {
        model.clientsInfo { [weak self] studentsPoints, floorLoading in
            guard let `self` = self else { return }
            
            switch floorLoading {
            case .high(let students):
                self.floorLoadingLabel.text = "High load"
                self.floorLoadingLabel.textColor = UIColor.warningRedColor
                self.usersCountLabel.text = "Students on selected floor: \(students)"
            case .medium(let students):
                self.floorLoadingLabel.text = "Medium load"
                self.floorLoadingLabel.textColor = UIColor.warningOrangeColor
                self.usersCountLabel.text = "Students on selected floor: \(students)"
            case .low(let students):
                self.floorLoadingLabel.text = "Low load"
                self.floorLoadingLabel.textColor = UIColor.successGreenColor
                self.usersCountLabel.text = "Students on selected floor: \(students)"
            }
            
            self.floorImageView.subviews.forEach { $0.removeFromSuperview() }
            for studentInfo in studentsPoints {
                let frame = CGRect(origin: studentInfo.value, size: CGSize(width: 10, height: 10))
                let studentDotView = UIView(frame: frame)
                studentDotView.layer.cornerRadius = 5
                studentDotView.backgroundColor = UIColor.warningRedColor
                studentDotView.tag = studentInfo.key
                self.floorImageView.addSubview(studentDotView)
            }
            completion()
        }
    }
}

extension FloorViewController: Toastable { }
