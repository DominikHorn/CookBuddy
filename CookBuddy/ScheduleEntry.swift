//
//  ScheduleEntry.swift
//  CookBuddy
//
//  Created by Dominik Horn on 16.04.17.
//  Copyright © 2017 Dominik Horn. All rights reserved.
//

import Foundation

struct ScheduleEntry {
    let id: Int
    let dishId: Int
    let scheduledFor: Date
    let numberOfPeople: Int
    
    init(id: Int, dishId: Int, scheduledFor: Date, numberOfPeople: Int = 1) {
        self.id = id
        self.dishId = dishId
        self.scheduledFor = scheduledFor
        self.numberOfPeople = numberOfPeople
    }
}
