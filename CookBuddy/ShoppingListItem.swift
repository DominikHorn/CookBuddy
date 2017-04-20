//
//  ShoppingListItem.swift
//  CookBuddy
//
//  Created by Dominik Horn on 20.04.17.
//  Copyright © 2017 Dominik Horn. All rights reserved.
//

import Foundation

struct ShoppingListItem {
    let ingredient: Ingredient
    var quantity: Float
    let belongsTo: Int
    let unit: String?
    
    init(ingredient: Ingredient, quantity: Float, belongsTo: Int, unit: String? = nil) {
        self.ingredient = ingredient
        self.quantity = quantity
        self.belongsTo = belongsTo
        self.unit = unit
    }
    
    mutating func add(quantity: Float) {
        self.quantity += quantity
    }
}
