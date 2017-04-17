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
        let cellSize = self.tableView.frame.height / CGFloat(self.numberOfCurrentDishes() + 1)
        if cellSize < 100 {
            return 100
        } else if cellSize > 200 {
            return 200
        } else {
            return cellSize
        }
    }
    
    @IBOutlet weak var calendarView: FSCalendar! {
        didSet {
            // Set monday as first weekday
            self.calendarView.firstWeekday = 2
            
            // Hide ugly title sides
            self.calendarView.appearance.headerMinimumDissolvedAlpha = 0.0
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            // Set tableview default row height
            self.tableView.rowHeight = tableViewRowHeight
            
            // Hide empty trailing cells
            self.tableView.tableFooterView = UIView()
        }
    }
    
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var addToScheduleButton: UIButton!
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
        self.present(controller, animated: true, completion: nil)
    }
    
    // Collection of all alerts that could not be presented earlier
    var databaseError: (() -> Void)?
    var currentDate: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Show all alerts
        self.databaseError?()
    }

    override func viewWillAppear(_ animated: Bool) {
        // Set navigation bar title
        self.navigationItem.title = "Planen"
        
        if Database.shared.updatesOccured {
            // Reload data (necessary, otherwise updates are not always shown)
            self.tableView.reloadData()
            self.calendarView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // revert back so that "back" button is titled normally
        self.navigationItem.title = nil
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
            self.databaseError = {
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
        self.currentDate = date
        
        // Make sure correct month is scrolled into view for date
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        
        // Change to week view
        self.calendarView.setScope(.week, animated: true)
        
        // Tell tableview to update
        self.tableView.reloadData()
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height;
        
        // Layout views
        self.view.layoutIfNeeded()
    }
}

// MARK:-- UITableViewDelegate
extension PlanViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: implement (show dish preview/allow editing of dish)
    }
}

// MARK:-- UITableViewDataSource
extension PlanViewController: UITableViewDataSource {
    // Calculates number of dishes that should currently be displayed
    func numberOfCurrentDishes() -> Int {
        return Database.shared.getDishesScheduled(forDate: self.currentDate)?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfCurrentDishes()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewRowHeight
    }
    
    // EDITING
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // EDITING
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // Get scheduled
            let scheduled = (Database.shared.getDishesScheduled(forDate: self.currentDate)?[indexPath.row])!
            
            // Delete from database
            Database.shared.deleteSchedule(entry: scheduled)
            
            // Query database again
            print((Database.shared.getDishesScheduled(forDate: self.currentDate)?.count)!)
            
            // Delete from tableview
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            // Upate calendar view
            self.calendarView.reloadData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableCell", for: indexPath) as! EventTableViewCell
        
        // retrieve scheduled at
        let scheduled = Database.shared.getDishesScheduled(forDate: self.currentDate)?[indexPath.row]
        
        // retrieve actual dish
        let dish = Database.shared.getDish(forId: (scheduled?.dishId)!)
        
        cell.dishTitelLabel.text = dish?.name
        cell.dishImageView.image = dish?.image
        let components = Calendar.current.dateComponents([.hour, .minute], from: (scheduled?.scheduledFor)!)
        cell.scheduleTimeLabel.text = String(format: "%02d:%02d", components.hour!, components.minute!)
        return cell
    }
}
