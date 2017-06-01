//
//  CustomShoppingListItems.swift
//  CookBuddy
//
//  Created by Dominik Horn on 23.05.17.
//  Copyright © 2017 Dominik Horn. All rights reserved.
//

import Foundation

struct CustomShoppingListItem {
    let canEdit: Bool = true
    let id: Int
    var bought: Bool {
        didSet {
            // Update database
            Database.shared.update(customShoppingListItem: self)
        }
    }
    
    var contents: String {
        didSet {
            // Automagically update backend db
            Database.shared.update(customShoppingListItem: self)
        }
    }
    
    init(id: Int, bought: Bool, initialContents: String = "") {
        self.id = id
        self.bought = bought
        self.contents = initialContents
    }
}
