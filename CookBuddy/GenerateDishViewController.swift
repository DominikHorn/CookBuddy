//
//  ViewController.swift
//  CookBuddy
//
//  Created by Dominik Horn on 11.04.17.
//  Copyright © 2017 Dominik Horn. All rights reserved.
//

import UIKit

class GenerateDishViewController: UIViewController {
    @IBOutlet weak var dishTitel: UILabel!
    @IBOutlet weak var dishDescription: UITextView!
    @IBOutlet weak var dishImage: UIImageView!
    
    // TODO: temporary
    var numberPool = [Int]()
    
    // necessary
    var currentSeque: UIStoryboardSegue?
    var date: Date?
    var currentDish: Dish?
    
    @IBAction func fetchNextDish(sender: UIButton?) {        
        let dishes = Database.shared.getAllDishes()
        
        if numberPool.isEmpty {
            for i in 0..<(dishes?.count)! {
                numberPool.append(i)
            }
        }
        
        let nextNumberIndex = Int(arc4random_uniform(UInt32(numberPool.count)))
        currentDish = dishes?[numberPool.remove(at: nextNumberIndex)]
        
        // Update UI
        dishTitel?.text = currentDish?.name
        dishDescription?.text = currentDish?.description
        dishImage?.image = currentDish?.image
    }
    
    @IBAction func confirmChoice(sender: UIBarButtonItem!) {
        // Schedule dish with database
        Database.shared.schedule(entry: ScheduleEntry(scheduledFor: date!, dishId: currentDish!.id))
        
        // Pop back to pervious view
        navigationController?.popViewController(animated: true)
    }
    @IBAction func abortChoice(sender: UIBarButtonItem!) {
        // Simply pop back
        navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var dateInputTextField: UITextField! {
        didSet {
            let timePicker = UIDatePicker()
            timePicker.datePickerMode = .time
            
            // Set date's default time to 18:00 o'clock if date exists
            if let datetmp = date {
                var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: datetmp)
                components.hour = 18
                components.minute = 00
                date = Calendar.current.date(from: components)!
                timePicker.date = date!
            } else {
                timePicker.date = Date()
            }
            
            timePicker.addTarget(self, action: #selector(selectedTimeChanged(sender:)), for: .valueChanged)
            dateInputTextField.inputView = timePicker
            let components = Calendar.current.dateComponents([.hour, .minute], from: timePicker.date)
            dateInputTextField.text = String(format: "%02d:%02d", components.hour!, components.minute!)
        }
    }
    func selectedTimeChanged(sender: UIDatePicker) {
        date = sender.date
        let components = Calendar.current.dateComponents([.hour, .minute], from: date!)
        dateInputTextField.text = String(format: "%02d:%02d", components.hour!, components.minute!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        currentSeque = segue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add observer for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // Fetch initial dish
        fetchNextDish(sender: nil)
        
        // Setup gesture recognizer for dismissing input views
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboards(recognizer:)))
        view.addGestureRecognizer(tapRecognizer)
    }
    
    func dismissKeyboards(recognizer: UIGestureRecognizer) {
        dateInputTextField.endEditing(true)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0 {
                view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y != 0 {
                view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
