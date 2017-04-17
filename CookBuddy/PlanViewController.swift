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
    // Table view helper variables
    var tableViewRowHeight: CGFloat {
        if numberOfCurrentDishes() > 0 {
            let cellSize = tableView.frame.height / CGFloat(numberOfCurrentDishes() + 1)
            if cellSize < 75 {
                return 75
            } else if cellSize > 150 {
                return 150
            } else {
                return cellSize
            }
        } else {
            return tableView.frame.height
        }
    }
    var lastContentOffset: CGFloat = 0.0
    
    // Global gesture recognizers
    lazy var swipeDownRecognizer: UISwipeGestureRecognizer = {
        let swipeDownRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeDownHappenedOnCalendar(gestureRecog:)))
        swipeDownRecognizer.direction = .down
        return swipeDownRecognizer
    }()
    lazy var swipeUpRecognizer: UISwipeGestureRecognizer = {
        let swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeUpHappenedOnCalendar(gestureRecog:)))
        swipeUpRecognizer.direction = .up
        return swipeUpRecognizer
    }()
    
    // Tab bar buttons button (done this way because they are conditionally displayed)
    lazy var addButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addToSchedule(sender:)))
    lazy var editButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(startTableViewEdit(sender:)))
    lazy var editDoneButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(endEdit))
    lazy var editDoneDeleteButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.trash, target: self, action: #selector(endTableViewEditDeleting(sender:)))
    
    // Calendar view helper
    @IBOutlet weak var calendarView: FSCalendar! {
        didSet {
            // Set monday as first weekday
            calendarView.firstWeekday = 2
            
            // Hide ugly title sides
            calendarView.appearance.headerMinimumDissolvedAlpha = 0.0
        }
    }
    func swipeUpHappenedOnCalendar(gestureRecog: UISwipeGestureRecognizer?) {
        if calendarView.scope == .month {
            // Set scope to week
            calendarView.setScope(.week, animated: true)
            
            // This will reload cell heights
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    func swipeDownHappenedOnCalendar(gestureRecog: UISwipeGestureRecognizer?) {
        if calendarView.scope == .week {
            // Set scope to month
            calendarView.setScope(.month, animated: true)
            
            // This will reload cell heights
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    var editSelection = [IndexPath]()
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            // Set tableview default row height
            tableView.rowHeight = tableViewRowHeight
            
            // Hide empty trailing cells
            tableView.tableFooterView = UIView()
        }
    }
    func deleteFromTableView(indexPaths iPaths: [IndexPath]) {
        if iPaths.count == 0 { return }
        
        var indexPaths = iPaths
        // Get scheduled
        if let scheduledDishes = Database.shared.getDishesScheduled(forDate: currentDate) {
            // Delete from database
            indexPaths.forEach {ipath in Database.shared.deleteSchedule(entry: scheduledDishes[ipath.row]) }

            if numberOfCurrentDishes() == 0 {
                // special edge case. Since we will insert an empty cell, this has to be done to prevent an internalinconsistency error
                indexPaths.removeLast()
            }
            
            // Delete from tableview
            tableView.deleteRows(at: indexPaths, with: .left)
        }
        
        // Reload both views for good measure
        tableView.reloadData()
        calendarView.reloadData()
    }
    func addToSchedule(sender: UIButton?) {
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
    func startTableViewEdit(sender: UIBarButtonItem?) {
        tableView.setEditing(true, animated: true)
        navigationItem.rightBarButtonItem = editDoneDeleteButton
        navigationItem.leftBarButtonItem = editDoneButton
    }
    func endTableViewEditDeleting(sender: UIBarButtonItem?) {
        // Delete all selected elements
        deleteFromTableView(indexPaths: editSelection)
        editSelection.removeAll()
        
        // End the edit
        endEdit()
    }
    
    func endEdit() {
        // Remove edit state
        tableView.setEditing(false, animated: false)
        
        // Conditionally add edit button
        navigationItem.setRightBarButton(addButton, animated: true)
        
        // Conditionally display edit button
        if numberOfCurrentDishes() > 0 {
            navigationItem.setLeftBarButton(editButton, animated: true)
        } else {
            navigationItem.setLeftBarButton(nil, animated: true)
        }
    }
    
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
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
        view.addGestureRecognizer(swipeUpRecognizer)
        view.addGestureRecognizer(swipeDownRecognizer)
    }
    func swipeRightGesture(gestureRecog: UISwipeGestureRecognizer) {
        // Select new date
        var components = DateComponents()
        components.day = -1
        currentDate = Calendar.current.date(byAdding: components, to: currentDate)!
        calendarView.select(currentDate, scrollToDate: true)
        
        // Reload tableview
        tableView.reloadSections(IndexSet(integer: 0), with: .right)
    
        // Make sure edit button is correctly displayed conditionally
        endEdit()
    }
    
    func swipeLeftGesture(gestureRecog: UISwipeGestureRecognizer) {
        // Select new date
        var components = DateComponents()
        components.day = 1
        currentDate = Calendar.current.date(byAdding: components, to: currentDate)!
        calendarView.select(currentDate, scrollToDate: true)
        
        // Reload tableview
        tableView.reloadSections(IndexSet(integer: 0), with: .left)
        
        // Make sure edit button is correctly displayed conditionally
        endEdit()
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
            endEdit()
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
        
        // Conditionally add or remove the edit button
        endEdit()
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
        if tableView.isEditing {
            // Add to selection list
            editSelection.append(indexPath)
        } else {
            // TODO: implement (show dish preview/allow editing of dish)
            print("Did select row at \(indexPath)")
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // Remove from selection list
        if tableView.isEditing {
            editSelection = editSelection.filter { element in
                element != indexPath
            }
        }
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
            deleteFromTableView(indexPaths: [indexPath])
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
