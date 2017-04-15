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
    @IBOutlet weak var calendarView: FSCalendar! {
        didSet {
            // Set monday as first weekday
            calendarView.firstWeekday = 2
            
            // Hide ugly title sides
            calendarView.appearance.headerMinimumDissolvedAlpha = 0.0
            
            // Change border
            calendarView.appearance.borderRadius = 5
        }
    }
    
    // Temporary for experimenting
    @IBAction func tempButtonClicked(button: UIButton!) {
        switch (self.calendarView.scope) {
        case .month:
            self.calendarView.setScope(.week, animated: true)
        case .week:
            self.calendarView.setScope(.month, animated: true)
        }
    }
    
    // Collection of all alerts that could not be presented earlier
    var databaseError: (() -> Void)?
    
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
        do {
            return try Database.shared.numberOfDishesScheduled(forDate: date)
        } catch {
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
        // Make sure correct month is scrolled into view for date
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        // Update bounds
        self.calendarView.frame = CGRect(origin: self.calendarView.frame.origin, size: bounds.size)
    }
}

// MARK:-- UITableViewDelegate
extension PlanViewController: UITableViewDelegate {
    
}

// MARK:-- UITableViewDataSource
extension PlanViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // Implement
    }
    
    
}
