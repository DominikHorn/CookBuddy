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
    
    init(scheduledFor: Date, dishId: Int, scheduleNumber: Int = 0) {
        self.scheduledFor = scheduledFor
        self.dishId = dishId
        self.scheduleNumber = scheduleNumber
    }
}
