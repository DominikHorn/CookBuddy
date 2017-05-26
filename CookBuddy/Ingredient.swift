//
//  Ingredient.swift
//  CookBuddy
//
//  Created by Dominik Horn on 16.04.17.
//  Copyright © 2017 Dominik Horn. All rights reserved.
//

import Foundation

struct Ingredient {
    let id: Int
    let name: String
    let plural: String?
    
    init(id: Int, name: String, plural: String? = nil) {
        self.id = id
        self.name = name
        self.plural = plural
    }
}
