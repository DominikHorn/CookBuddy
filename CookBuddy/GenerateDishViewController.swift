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
    
    @IBOutlet weak var confirmButton: UIButton! {
        didSet {
            let image = UIImage(named: "circletick")?.withRenderingMode(.alwaysTemplate)
            self.confirmButton.setImage(image, for: .normal)
            // self.confirmButton.tintColor = UIColor.blue
            // self.confirmButton.setImage(UIImage(emoji: "✔︎\u{20DD}").withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
    @IBAction func confirmChoice(sender: UIButton!) {
        // Schedule dish with database
        Database.shared.schedule(dish: self.currentDish!, forDate: self.date!)
        
        // Pop back to pervious view
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var abortButton: UIButton! {
        didSet {
            let image = UIImage(named: "circlecross")?.withRenderingMode(.alwaysTemplate)
            self.abortButton.setImage(image, for: .normal)
            // self.abortButton.tintColor = UIColor.blue
            // self.abortButton.setImage(UIImage(emoji: "✘\u{20DD}"), for: .normal)
        }
    }
    @IBAction func abortChoice(sender: UIButton!) {
        // Simply pop back
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var dateInputTextField: UITextField! {
        didSet {
            let timePicker = UIDatePicker()
            timePicker.datePickerMode = .time
            timePicker.date = self.date ?? Date()
            timePicker.addTarget(self, action: #selector(selectedTimeChanged(sender:)), for: .valueChanged)
            self.dateInputTextField.inputView = timePicker
            self.dateInputTextField.text = "18:00"
        }
    }
    func selectedTimeChanged(sender: UIDatePicker) {
        self.date = sender.date
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: self.date!)
        self.dateInputTextField.text = "\(components.hour!):\(components.minute!)"
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
