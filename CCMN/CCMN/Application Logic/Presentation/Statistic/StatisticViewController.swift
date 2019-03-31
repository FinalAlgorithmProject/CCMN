//
//  StatisticViewController.swift
//  CCMN
//
//  Created by Vitalii Poltavets on 3/10/19.
//  Copyright © 2019 unit. All rights reserved.
//

import UIKit
import Charts
import Lottie

class StatisticViewController: UIViewController {
    
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var lottieView: UIView!
    
    var model: StatisticModel!
    private var startDatePicker: UIDatePicker!
    private var endDatePicker: UIDatePicker!
    
    private lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Analytics and Presence"
        
        startDatePicker = createDatePicker()
        endDatePicker = createDatePicker()
        
        startDateTextField.inputView = startDatePicker
        startDateTextField.layer.borderColor = NCApplicationConstants.mainRedColor.cgColor
        startDateTextField.layer.borderWidth = 1.5
        startDateTextField.layer.cornerRadius = 10
        startDateTextField.clipsToBounds = true
        startDateTextField.delegate = self
        
        endDateTextField.inputView = endDatePicker
        endDateTextField.layer.borderColor = NCApplicationConstants.mainRedColor.cgColor
        endDateTextField.layer.borderWidth = 1.5
        endDateTextField.layer.cornerRadius = 10
        endDateTextField.clipsToBounds = true
        endDateTextField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let lotView = LOTAnimationView(name: "LookingAround")
        lotView.frame = lottieView.bounds
        lotView.contentMode = .scaleAspectFit
        lottieView.addSubview(lotView)
        lotView.play { finish in
            if finish { lotView.play() }
        }
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
    
    @IBAction func dwellTime(_ sender: UIButton) {
        model.openDwellTimeStatistic()
    }
    
    @IBAction func passerby(_ sender: UIButton) {
        model.openPasserbyStatistic()
    }
    
    @IBAction func connectedUsers(_ sender: UIButton) {
        model.openConnectedUsers()
    }
    
    @IBAction func visitors(_ sender: UIButton) {
        model.openVisitorsStatistic()
    }
    
    @IBAction func forecast(_ sender: UIButton) {
        model.openForecasting()
    }
}

extension StatisticViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == startDateTextField {
            let stringDate = formatter.string(from: startDatePicker.date)
            startDateTextField.text = stringDate
            model.startDate = stringDate
        } else if textField == endDateTextField {
            let stringDate = formatter.string(from: endDatePicker.date)
            endDateTextField.text = stringDate
            model.endDate = stringDate
        }
    }
}















