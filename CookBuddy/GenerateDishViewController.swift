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
        self.currentDish = dishes?[numberPool.remove(at: nextNumberIndex)]
        
        // Update UI
        self.dishTitel?.text = self.currentDish?.name
        self.dishDescription?.text = self.currentDish?.description
        self.dishImage?.image = self.currentDish?.image
    }
    
    @IBAction func confirmChoice(sender: UIBarButtonItem!) {
        // Schedule dish with database
        Database.shared.schedule(entry: ScheduleEntry(scheduledFor: self.date!, dishId: self.currentDish!.id))
        
        // Pop back to pervious view
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func abortChoice(sender: UIBarButtonItem!) {
        // Simply pop back
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var dateInputTextField: UITextField! {
        didSet {
            let timePicker = UIDatePicker()
            timePicker.datePickerMode = .time
            
            // Set date's default time to 18:00 o'clock if self.date exists
            if let datetmp = self.date {
                var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: datetmp)
                components.hour = 18
                components.minute = 00
                self.date = Calendar.current.date(from: components)!
                timePicker.date = self.date!
            } else {
                timePicker.date = Date()
            }
            
            timePicker.addTarget(self, action: #selector(selectedTimeChanged(sender:)), for: .valueChanged)
            self.dateInputTextField.inputView = timePicker
            let components = Calendar.current.dateComponents([.hour, .minute], from: timePicker.date)
            self.dateInputTextField.text = String(format: "%02d:%02d", components.hour!, components.minute!)
        }
    }
    func selectedTimeChanged(sender: UIDatePicker) {
        self.date = sender.date
        let components = Calendar.current.dateComponents([.hour, .minute], from: self.date!)
        self.dateInputTextField.text = String(format: "%02d:%02d", components.hour!, components.minute!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.currentSeque = segue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add observer for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // Fetch initial dish
        self.fetchNextDish(sender: nil)
        
        // Setup gesture recognizer for dismissing input views
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboards(recognizer:)))
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    func dismissKeyboards(recognizer: UIGestureRecognizer) {
        self.dateInputTextField.endEditing(true)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
