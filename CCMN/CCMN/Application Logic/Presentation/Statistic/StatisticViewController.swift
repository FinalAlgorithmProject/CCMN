//
//  StatisticViewController.swift
//  CCMN
//
//  Created by Vitalii Poltavets on 3/10/19.
//  Copyright © 2019 unit. All rights reserved.
//

import UIKit
import Charts

class StatisticViewController: UIViewController {
    
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    var model: StatisticModel!
    
    private lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Analytics and Presence"
        
        let startDatePicker = createDatePicker()
        startDatePicker.addTarget(self, action: #selector(startDateChange), for: .valueChanged)
        
        let endDatePicker = createDatePicker()
        endDatePicker.addTarget(self, action: #selector(endDateChange), for: .valueChanged)
        
        startDateTextField.inputView = startDatePicker
        startDateTextField.layer.borderColor = NCApplicationConstants.mainRedColor.cgColor
        startDateTextField.layer.borderWidth = 1.5
        startDateTextField.layer.cornerRadius = 10
        startDateTextField.clipsToBounds = true
        
        endDateTextField.inputView = endDatePicker
        endDateTextField.layer.borderColor = NCApplicationConstants.mainRedColor.cgColor
        endDateTextField.layer.borderWidth = 1.5
        endDateTextField.layer.cornerRadius = 10
        endDateTextField.clipsToBounds = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        model.startDate = nil
        model.endDate = nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func createDatePicker() -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        return datePicker
    }
    
    // MARK: Actions
    @IBAction func repeatedVisitors(_ sender: UIButton) {
        model.openRepeatedVisitors()
    }
    
    @objc func startDateChange(_ sender: UIDatePicker) {
        let stringDate = formatter.string(from: sender.date)
        startDateTextField.text = stringDate
        model.startDate = stringDate
    }
    
    @objc func endDateChange(_ sender: UIDatePicker) {
        let stringDate = formatter.string(from: sender.date)
        endDateTextField.text = stringDate
        model.endDate = stringDate
    }
}
