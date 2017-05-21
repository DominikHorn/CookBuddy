//
//  DishDetailViewController.swift
//  CookBuddy
//
//  Created by Dominik Horn on 17.04.17.
//  Copyright © 2017 Dominik Horn. All rights reserved.
//

import UIKit

class DishDetailViewController: UIViewController {
    @IBOutlet weak var dishTitel: UILabel! {
        didSet {
            dishTitel.text = dish?.name
        }
    }
    @IBOutlet weak var dishDescription: UITextView! {
        didSet {
            dishDescription.text = dish?.description
            if (dish?.ingredients?.count)! > 0 {
                dishDescription.text = dishDescription.text + "\n\nZutaten:"
                for (index, ing) in (dish?.ingredients)!.enumerated() {
                    // TODO: Add ingredient amount
                    dishDescription.text = dishDescription.text + "\n\(index + 1). \(ing.name)"
                }
            }
            
            // Resize according to content
            let fixedWidth = dishDescription.frame.size.width
            dishDescription.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
            let newSize = dishDescription.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
            var newFrame = dishDescription.frame
            newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
            dishDescription.frame = newFrame;
        }
    }
    @IBOutlet weak var dishImage: UIImageView! {
        didSet {
            dishImage.image = dish?.image
        }
    }
    fileprivate var timeCell: TimePickerCell?
    fileprivate var numberCell: NumberPickerCell?
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            // Remove trailing empty cells
            tableView.tableFooterView = UIView()
        }
    }
    @IBOutlet weak var scrollView: UIScrollView!
    
    // dish to be displayed in detail
    var dish: Dish?
    
    // Whether or not this dish detail is used for adding
    var canAdd: Bool = false
    
    // Triggered by add button
    func addToSchedule(sender: UIBarButtonItem) {
        // Obtain number of people
        let numberOfPeople = numberCell?.number ?? 3
        let date = timeCell?.currentDate ?? Date()
        
        Database.shared.schedule(entry: ScheduleEntry(scheduledFor: date, dishId: (dish?.id)!, numberOfPeople: numberOfPeople))
        
        navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (canAdd) {
            navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addToSchedule(sender:))), animated: true)
            tableView.frame = CGRect(origin: tableView.frame.origin, size: CGSize(width: tableView.frame.width, height: 200))
            tableView.isHidden = false;
        } else {
            tableView.frame = CGRect(origin: tableView.frame.origin, size: CGSize(width: tableView.frame.width, height: 0))
            tableView.isHidden = true;
        }
        scrollView.layoutIfNeeded()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add observer for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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

// MARK:-- Tableview delegate
extension DishDetailViewController: UITableViewDelegate {
    // empty for now
}

extension DishDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NumberCell") as! NumberPickerCell
            cell.prefix = "Personenanzahl"
            cell.number = 3
            numberCell = cell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimeCell") as! TimePickerCell
            cell.currentDate = Database.shared.currentDate
            timeCell = cell
            return cell
        default:
            print("Error invalid index for table view")
        }
        
        return UITableViewCell()
    }
}
