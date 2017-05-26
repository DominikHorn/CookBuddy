//
//  ShoppingListItem.swift
//  CookBuddy
//
//  Created by Dominik Horn on 23.05.17.
//  Copyright © 2017 Dominik Horn. All rights reserved.
//

import Foundation

protocol ShoppingListItem {
    // Whether or not the shopping list item may be edited
    var canEdit: Bool { get }
    
    // Text contents that should be displayed
    var contents: String { get }
    
    // Whether or not the item has been bought
    var bought: Bool { get set }
    
    // The database id of this item
    var id: Int { get }
}
