//
//  ForcedShoppingListItem.swift
//  CookBuddy
//
//  Created by Dominik Horn on 23.05.17.
//  Copyright © 2017 Dominik Horn. All rights reserved.
//

import Foundation

struct ForcedShoppingListItem: ShoppingListItem {
    let canEdit: Bool = false
    let id: Int
    let ingId: Int
    let scheduleId: Int
    var bought: Bool {
        didSet {
            // Update database
            Database.shared.update(shoppingListItem: self)
        }
    }
    var contents: String {
        return "Not implemented" // todo fetch all data
    }
    
    init(id: Int, ingId: Int, scheduleId: Int, bought: Bool = false) {
        self.id = id
        self.scheduleId = scheduleId
        self.bought = bought
        self.ingId = ingId
    }
}
