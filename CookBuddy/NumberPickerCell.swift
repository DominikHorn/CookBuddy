//
//  NumberPickerCell.swift
//  CookBuddy
//
//  Created by Dominik Horn on 18.04.17.
//  Copyright © 2017 Dominik Horn. All rights reserved.
//

import UIKit

class NumberPickerCell: UITableViewCell {
    var prefix: String? {
        didSet {
            updateText()
        }
    }
    var number: Int = 0 {
        didSet {
            updateText()
        }
    }
    // TODO: replace with +/- picker
    @IBOutlet weak var numberPickerField: UITextField! {
        didSet {
            // Hide caret
            numberPickerField.tintColor = UIColor.clear
            
            // Configure input ticker
            let picker = UIPickerView()
            picker.delegate = self
            picker.dataSource = self
            
            // Configure input view
            numberPickerField.inputView = picker
            
            updateText()
        }
    }
    func updateText() {
        if numberPickerField != nil {
            (numberPickerField.inputView as! UIPickerView).selectRow(number - 1, inComponent: 0, animated: true)
            numberPickerField.text = (prefix ?? "Zahl:") + " \(number)"
        }
    }
}

extension NumberPickerCell: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(format: "%d", (row + 1))
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        number = row + 1
        updateText()
    }
}

extension NumberPickerCell: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
}

extension NumberPickerCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}
