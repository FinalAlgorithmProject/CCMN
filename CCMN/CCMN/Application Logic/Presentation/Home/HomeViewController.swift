//
//  HomeViewController.swift
//  CCMN
//
//  Created by Vitalii Poltavets on 3/10/19.
//  Copyright © 2019 unit. All rights reserved.
//

import UIKit
import Charts

class HomeViewController: UIViewController {

    @IBOutlet weak var todayVisitorsDifferenceLabel: UILabel!
    @IBOutlet weak var onlineUsersDifferenceLabel: UILabel!
    @IBOutlet weak var pieChartsView: PieChartView!
    @IBOutlet weak var totalDeviceConnectedLabel: UILabel!
    @IBOutlet weak var todayVisitorsLabel: UILabel!
    @IBOutlet weak var ciscoIconImage: UIImageView!
    @IBOutlet weak var buildingNameLabel: UILabel! {
        didSet {
            buildingNameLabel.text = model.buildingName
        }
    }
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.delegate = self
        searchBar.autocapitalizationType = .none
        searchBar.autocorrectionType = .no
        searchBar.placeholder = "Search by MAC address or xlogin(username)"
        return searchBar
    }()
    
    var model: HomeModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initNavigation()
        initChart()
        startAnimation()
    
        model.usersOnline { count, userDifference in
            switch userDifference {
            case .equel(let value):
                self.onlineUsersDifferenceLabel.text = "🤝 \(value)"
                self.onlineUsersDifferenceLabel.textColor = NCApplicationConstants.mainBlackColor
            case .down(let value):
                self.onlineUsersDifferenceLabel.text = "👇 \(value)"
                self.onlineUsersDifferenceLabel.textColor = UIColor.warningRedColor
            case .up(let value):
                self.onlineUsersDifferenceLabel.text = "👆 \(value)"
                self.onlineUsersDifferenceLabel.textColor = UIColor.successGreenColor
            }
            self.totalDeviceConnectedLabel!.text = "Users online: \(count)"
            
        }
        model.todayVisitors { count, userDifference in
            switch userDifference {
            case .equel(let value):
                self.todayVisitorsDifferenceLabel.text = "🤝 \(value)"
                self.todayVisitorsDifferenceLabel.textColor = NCApplicationConstants.mainBlackColor
            case .down(let value):
                self.todayVisitorsDifferenceLabel.text = "👇 \(value)"
                self.todayVisitorsDifferenceLabel.textColor = UIColor.warningRedColor
            case .up(let value):
                self.todayVisitorsDifferenceLabel.text = "👆 \(value)"
                self.todayVisitorsDifferenceLabel.textColor = UIColor.successGreenColor
            }
            self.todayVisitorsLabel!.text = "Today visitors: \(count)"
        }
        model.allClients { macAddress, userName, userLocation in
            print("New user from: \(userLocation)")
            if !userName.isEmpty {
                self.showToastLabel(with: "Hi, \"\(userName)\" and MAC address (\(macAddress)) now is on \(userLocation)")
            } else {
                self.showToastLabel(with: "Hi, MAC address \"\(macAddress)\" now is on \(userLocation)")
            }
            
        }
        model.todayKPI { data in
            self.pieChartsView.data = data
            self.pieChartsView.animate(xAxisDuration: 1.5, easingOption: .easeOutBack)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.endEditing(true)
    }
    
    private func initNavigation() {
        let refreshItem = UIBarButtonItem(barButtonSystemItem: .refresh,
                                          target: self,
                                          action: #selector(reloadData))
        navigationItem.rightBarButtonItem = refreshItem
        navigationItem.titleView = searchBar
    }
    
    private func initChart() {
        pieChartsView.chartDescription?.text = ""
    }
    
    private func startAnimation() {
        UIView.animate(withDuration: 1) {
            let degrees: Float = 250
            let radians = CGFloat(degrees * Float.pi / 180)
            self.ciscoIconImage.transform = CGAffineTransform(scaleX: 3, y: 3).rotated(by: radians)
            self.ciscoIconImage.alpha = 0
        }
    }
    
    @objc func reloadData() {
        model.refreshUserData()
        showToastLabel(with: "Succefully refreshed!",
                       backgroundColor: UIColor.successGreenColor)
    }
}

extension HomeViewController: Toastable { }

extension HomeViewController: UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if (searchBar.text?.isEmpty ?? true) { return }
        model.searchUser(by: searchBar.text!) { [weak self] result, index in
            guard let `self` = self else { return }
            
            if let user = result, let index = index {
                let alert = UIAlertController(title: "Success",
                                              message: "Do you want to be redirect to user location?",
                                              preferredStyle: .alert)
                let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { _ in
                    self.model.redirectWithUser(user, withIndex: index)
                })
                alert.addAction(yesAction)
                alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                self.showToastLabel(with: "Sorry, but we can't find: \"\(searchBar.text!)\" :(",
                                     backgroundColor: UIColor.warningRedColor)
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}






