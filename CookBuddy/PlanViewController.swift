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
    let tableViewRowHeight: CGFloat = 150
    
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
        }
    }
    
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
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
    
}

// MARK:-- UITableViewDataSource
extension PlanViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Count
        if let count = Database.shared.getDishesScheduled(forDate: self.currentDate)?.count {
            return count
        }
        
        // 0 otherwise (TODO: display a message if no content is available)
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewRowHeight
    }
    
    // Implement this for more performance
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewRowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableCell", for: indexPath) as! EventTableViewCell
        let dish = Database.shared.getDishesScheduled(forDate: self.currentDate)?[indexPath.row]
        
        cell.dishTitelLabel.text = dish?.name
        cell.dishImageView.image = dish?.image
        cell.scheduleTimeLabel.text = "18:00" // TODO
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // Implement
    }
    
    
}
