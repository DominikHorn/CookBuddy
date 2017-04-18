//
//  TimePickerCell.swift
//  CookBuddy
//
//  Created by Dominik Horn on 18.04.17.
//  Copyright © 2017 Dominik Horn. All rights reserved.
//

import UIKit

class TimePickerCell: UITableViewCell {
    var currentDate: Date? {
        didSet {
            updateDisplayedDate(date: currentDate ?? Date())
        }
    }
    
    @IBOutlet weak var timePickerField: UITextField! {
        didSet {
            // Hide caret
            timePickerField.tintColor = UIColor.clear
            
            // Configure input view
            let timePicker = UIDatePicker()
            timePicker.datePickerMode = .time
            timePicker.addTarget(self, action: #selector(selectedTimeChanged(sender:)), for: .valueChanged)
            timePickerField.inputView = timePicker
            
            // Make sure we have a date
            if currentDate == nil {
                currentDate = Date()
            }
            
            // Set timepicker date
            timePicker.date = currentDate!
        }
    }
    func selectedTimeChanged(sender: UIDatePicker) {
        // This will update the text view aswell
        currentDate = sender.date
    }
    func updateDisplayedDate(date: Date) {
        if timePickerField != nil {
            let components = Calendar.current.dateComponents([.hour, .minute], from: date)
            timePickerField.text = String(format: "Essenszeit: %02d:%02d", components.hour!, components.minute!)

        }
    }
}

extension TimePickerCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}
