//
//  Dish.swift
//  CookBuddy
//
//  Created by Dominik Horn on 16.04.17.
//  Copyright © 2017 Dominik Horn. All rights reserved.
//

import UIKit

// Dish encapsulates a single dish
struct Dish: Hashable {
    let id: Int
    let name: String
    let ingredients: [Ingredient]?
    let description: String?
    let shortDescription: String?
    let image: UIImage?
    
    var hashValue: Int {
        // Id is guaranteed to be unique -> perfect hash function
        return id
    }
    
    static func == (lhs: Dish, rhs: Dish) -> Bool {
        return lhs.id == rhs.id
    }
    
    init(id: Int, name: String, ingredients: [Ingredient]? = nil, description: String? = nil, imageName: String? = nil) {
        self.id = id
        self.name = name
        self.ingredients = ingredients
        self.description = description
        self.shortDescription = self.description // TODO
        self.image = UIImage(contentsOfFile: Bundle.main.path(forResource: imageName, ofType: "jpg", inDirectory: "DishImages")!)
    }
}
