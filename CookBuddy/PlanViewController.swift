//
//  PlanViewController.swift
//  CookBuddy
//
//  Created by Dominik Horn on 14.04.17.
//  Copyright © 2017 Dominik Horn. All rights reserved.
//

import UIKit
import FSCalendar

class PlanViewController: UIViewController {
    // constants
    var tableViewRowHeight: CGFloat {
        if numberOfCurrentDishes() > 0 {
            let cellSize = tableView.frame.height / CGFloat(numberOfCurrentDishes() + 1)
            if cellSize < 100 {
                return 100
            } else if cellSize > 200 {
                return 200
            } else {
                return cellSize
            }
        } else {
            return tableView.frame.height
        }
    }
    
    @IBOutlet weak var calendarView: FSCalendar! {
        didSet {
            // Set monday as first weekday
            calendarView.firstWeekday = 2
            
            // Hide ugly title sides
            calendarView.appearance.headerMinimumDissolvedAlpha = 0.0
            
            // Swipe down gesture enlarges calendar view
            let swipeDownRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeDownHappenedOnCalendar(gestureRecog:)))
            swipeDownRecognizer.direction = .down
            let swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeUpHappenedOnCalendar(gestureRecog:)))
            swipeUpRecognizer.direction = .up
            calendarView.addGestureRecognizer(swipeDownRecognizer)
            calendarView.addGestureRecognizer(swipeUpRecognizer)
        }
    }
    func swipeUpHappenedOnCalendar(gestureRecog: UISwipeGestureRecognizer) {
        if calendarView.scope == .month {
            // Set scope to week
            calendarView.setScope(.week, animated: true)
            
            // This will reload cell heights
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    func swipeDownHappenedOnCalendar(gestureRecog: UISwipeGestureRecognizer) {
        if calendarView.scope == .week {
            // Set scope to month
            calendarView.setScope(.month, animated: true)
            
            // This will reload cell heights
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            // Set tableview default row height
            tableView.rowHeight = tableViewRowHeight
            
            // Hide empty trailing cells
            tableView.tableFooterView = UIView()
        }
    }
    
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    @IBAction func addToSchedule(sender: UIButton?) {
        // Present slide over menu from bottom
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let generateDishAction = UIAlertAction(title: "Automatisch generieren", style: .default) {
            [unowned self] alertAction in
            let genDishContr: GenerateDishViewController = (self.storyboard?.instantiateViewController(withIdentifier: "GenerateDish"))! as! GenerateDishViewController
            genDishContr.date = self.currentDate
            self.show(genDishContr, sender: self)
        }
        let chooseManualAction = UIAlertAction(title: "Manuel wählen", style: .default) {
            alertAction in
            print("Choose manual action")
        }
        let cancelDishAction = UIAlertAction(title: "Abbrechen", style: .cancel, handler: nil)
        controller.addAction(generateDishAction)
        controller.addAction(chooseManualAction)
        controller.addAction(cancelDishAction)
        controller.preferredAction = generateDishAction
        present(controller, animated: true, completion: nil)
    }
    
    // Collection of all alerts that could not be presented earlier
    var databaseError: (() -> Void)?
    var currentDate: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add swipe right and left recognizer
        let rightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeRightGesture(gestureRecog:)))
        rightRecognizer.direction = .right
        let leftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeftGesture(gestureRecog:)))
        leftRecognizer.direction = .left
        view.addGestureRecognizer(rightRecognizer)
        view.addGestureRecognizer(leftRecognizer)
    }
    func swipeRightGesture(gestureRecog: UISwipeGestureRecognizer) {
        // Select new date
        var components = DateComponents()
        components.day = -1
        currentDate = Calendar.current.date(byAdding: components, to: currentDate)!
        calendarView.select(currentDate, scrollToDate: true)
        
        // Reload tableview
        tableView.reloadSections(IndexSet(integer: 0), with: .right)
    }
    
    func swipeLeftGesture(gestureRecog: UISwipeGestureRecognizer) {
        // Select new date
        var components = DateComponents()
        components.day = 1
        currentDate = Calendar.current.date(byAdding: components, to: currentDate)!
        calendarView.select(currentDate, scrollToDate: true)
        
        // Reload tableview
        tableView.reloadSections(IndexSet(integer: 0), with: .left)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Show all alerts
        databaseError?()
    }

    override func viewWillAppear(_ animated: Bool) {
        // Set navigation bar title
        navigationItem.title = "Planen"
        
        if Database.shared.updatesOccured {
            // Reload data (necessary, otherwise updates are not always shown)
            tableView.reloadData()
            calendarView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // revert back so that "back" button is titled normally
        navigationItem.title = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK:-- FSCalendarDateSource
extension PlanViewController: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        // Query events
        if let count = Database.shared.getDishesScheduled(forDate: date)?.count {
            return count
        } else {
            databaseError = {
                [unowned self] in
                let alert = UIAlertController(title: "Datenbank ist kaputt 😬", message: "Frage eine qualifizierte Fachkraft (deinen Sohn) was das soll: \(#function)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okidoki 🙄", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        return 0
    }
}

// MARK:-- FSCalendarDelegate
extension PlanViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // Update current date
        currentDate = date
        
        // Make sure correct month is scrolled into view for date
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        
        // Change to week view
        calendarView.setScope(.week, animated: true)
        
        // Tell tableview to update
        tableView.reloadData()
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeightConstraint.constant = bounds.height;
        
        // Layout views
        view.layoutIfNeeded()
    }
}

// MARK:-- UITableViewDelegate
extension PlanViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: implement (show dish preview/allow editing of dish)
        print("Did select row at \(indexPath)")
    }
}

// MARK:-- UITableViewDataSource
extension PlanViewController: UITableViewDataSource {
    // Calculates number of dishes that should currently be displayed
    func numberOfCurrentDishes() -> Int {
        return Database.shared.getDishesScheduled(forDate: currentDate)?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = numberOfCurrentDishes()
        
        // Switch between "No scheduled dishes" and scheduled dishes. Set interactivity accordingly
        if count == 0 {
            count = 1
            tableView.isUserInteractionEnabled = false
        } else {
            tableView.isUserInteractionEnabled = true
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewRowHeight
    }
    
    // EDITING
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return numberOfCurrentDishes() > 0
    }
    
    // EDITING
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // Get scheduled
            let scheduled = (Database.shared.getDishesScheduled(forDate: currentDate)?[indexPath.row])!
            
            // Delete from database
            Database.shared.deleteSchedule(entry: scheduled)
            
            // Query database again (We have to do this. Otherwise we get an NSInternalInconsistencyError)
            if numberOfCurrentDishes() > 1 {
                // Delete from tableview
                tableView.deleteRows(at: [indexPath], with: .automatic)
            } else {
                // Simply reload data
                tableView.reloadData()
            }
            // Upate calendar view
            calendarView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    // Implement this for more performance
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewRowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if numberOfCurrentDishes() > 0 {
            // Dequeue cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableCell") as! EventTableViewCell
            
            // Obtain scheduled for index path
            let scheduled = Database.shared.getDishesScheduled(forDate: currentDate)?[indexPath.row]
            
            // retrieve actual dish
            let dish = Database.shared.getDish(forId: (scheduled?.dishId)!)
            
            cell.dishTitelLabel.text = dish?.name
            cell.dishImageView.image = dish?.image
            let components = Calendar.current.dateComponents([.hour, .minute], from: (scheduled?.scheduledFor)!)
            cell.scheduleTimeLabel.text = String(format: "%02d:%02d", components.hour!, components.minute!)
            return cell
        } else {
            // return empty cell
            return tableView.dequeueReusableCell(withIdentifier: "EmptyMessageCell")!
        }
    }
}
