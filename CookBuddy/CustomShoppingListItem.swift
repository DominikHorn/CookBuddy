//
//  CustomShoppingListItems.swift
//  CookBuddy
//
//  Created by Dominik Horn on 23.05.17.
//  Copyright © 2017 Dominik Horn. All rights reserved.
//

import Foundation

struct CustomShoppingListItem: ShoppingListItem {
    let canEdit: Bool = true
    let id: Int
    var bought: Bool {
        didSet {
            // Update database
            Database.shared.update(shoppingListItem: self)
        }
    }
    
    private var _contents: String
    var contents: String {
        get {
            return _contents
        }
        
        set {
            // Set new value
            _contents = newValue
            
            // Automagically update backend db
            Database.shared.update(customShoppingListItem: self)
        }
    }
    
    init(id: Int, bought: Bool, initialContents: String = "") {
        self.id = id
        self.bought = bought
        _contents = initialContents
    }
}
