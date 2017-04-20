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
    var currentDish: Dish?
    var currentDate: Date? {
        didSet {
            timeCell?.currentDate = currentDate
        }
    }
    
    // Keep track of the cells to be able to write back changes
    var timeCell: TimePickerCell?
    var numberCell: NumberPickerCell?
    
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
        Database.shared.schedule(entry: ScheduleEntry(scheduledFor: timeCell?.currentDate ?? Date(), dishId: currentDish!.id, numberOfPeople: numberCell?.number ?? 1))
        
        // Pop back to pervious view
        navigationController?.popViewController(animated: true)
    }
    @IBAction func abortChoice(sender: UIBarButtonItem!) {
        // Simply pop back
        navigationController?.popViewController(animated: true)
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
    
    // MARK:- Keyboard/Input handeling
    func dismissKeyboards(recognizer: UIGestureRecognizer) {
        self.view.endEditing(true)
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

// MARK:- UITableViewDelegate
extension GenerateDishViewController: UITableViewDelegate {
    
}

// MARK:- UITableViewDataSource
extension GenerateDishViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    var headerHeight: CGFloat {
        return 1.5
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: headerHeight))
        view.backgroundColor = UIColor.lightGray
        return view
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        // Footer is the same as header
        return self.tableView(tableView, viewForHeaderInSection: section)
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return headerHeight
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch(indexPath.row) {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimePickerCell") as! TimePickerCell
            
            // Asign default time of 18:00
            var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: currentDate!)
            components.hour = 18
            components.minute = 0
            cell.currentDate = Calendar.current.date(from: components)
            timeCell = cell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NumberPickerCell") as! NumberPickerCell
            cell.prefix = "Personenanzahl:"
            cell.number = 3
            numberCell = cell
            return cell
        default:
            return UITableViewCell()
        }
    }
}
