//
//  ShoppingListCell.swift
//  CookBuddy
//
//  Created by Dominik Horn on 18.04.17.
//  Copyright © 2017 Dominik Horn. All rights reserved.
//

import UIKit

class ShoppingListCell: UITableViewCell {
    private static var counter = 1
    @IBOutlet weak var ingredientTextField: UITextField! {
        didSet {
            ingredientTextField.text = "\(ShoppingListCell.counter). Zutat"
            ShoppingListCell.counter+=1
        }
    }
}
