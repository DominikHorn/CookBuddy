//
//  Dish.swift
//  CookBuddy
//
//  Created by Dominik Horn on 16.04.17.
//  Copyright © 2017 Dominik Horn. All rights reserved.
//

import UIKit

// Dish encapsulates a single dish
struct Dish {
    let id: Int
    let name: String
    let ingredients: [String]?
    let description: String?
    let shortDescription: String?
    let image: UIImage?
    
    init(id: Int, name: String, ingredients: [String]? = nil, description: String? = nil, imageName: String? = nil) {
        self.id = id
        self.name = name
        self.ingredients = ingredients
        self.description = description
        self.shortDescription = self.description // TODO
        self.image = UIImage(contentsOfFile: Bundle.main.path(forResource: imageName, ofType: "jpg", inDirectory: "DishImages")!)
    }
}
