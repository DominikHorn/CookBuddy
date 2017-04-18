//
//  ScheduleEntry.swift
//  CookBuddy
//
//  Created by Dominik Horn on 16.04.17.
//  Copyright © 2017 Dominik Horn. All rights reserved.
//

import Foundation

struct ScheduleEntry {
    let scheduledFor: Date
    let dishId: Int
    let scheduleNumber: Int
    let numberOfPeople: Int
    
    init(scheduledFor: Date, dishId: Int, numberOfPeople: Int = 1, scheduleNumber: Int = -1) {
        self.scheduledFor = scheduledFor
        self.dishId = dishId
        self.numberOfPeople = numberOfPeople
        
        if scheduleNumber < 0 {
            // TODO: Find a better solution than this schedulenumber
            self.scheduleNumber = Database.shared.getDishesScheduled(forDate: scheduledFor)?.count ?? 0
        } else {
            self.scheduleNumber = scheduleNumber
        }
    }
}
