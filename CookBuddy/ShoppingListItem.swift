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
    
    public var description: String {
        let nameString: String = (quantity > 1 && unit == nil ? ("\(ingredient.plural ?? ingredient.name)") : "\(ingredient.name)")
        return String(format: "\(prettify(quantity)) " + (unit == nil ? "" : "\(unit!) ") + nameString)
    }
    
    func prettify(_ float: Float) -> String {
        if float == float.rounded(.toNearestOrAwayFromZero) {
            // If number is .0, return just integer part
            return String(format: "%d", Int(float))
        } else {
            // Else return pretty fraction
            let num = Int(float)
            let rational = rationalApproximation(of: Double(float - Float(num)))
            
            if num == 0 {
                return String(format: "%d/%d", rational.num, rational.den)
            } else {
                return String(format: "%d %d/%d", num, rational.num, rational.den)
            }
        }
    }
    
    typealias Rational = (num : Int, den : Int)
    
    func rationalApproximation(of x0 : Double, withPrecision eps : Double = 1.0E-6) -> Rational {
        var x = x0
        var a = x.rounded(.down)
        var (h1, k1, h, k) = (1, 0, Int(a), 1)
        
        while x - a > eps * Double(k) * Double(k) {
            x = 1.0/(x - a)
            a = x.rounded(.down)
            (h1, k1, h, k) = (h, k, h1 + Int(a) * h, k1 + Int(a) * k)
        }
        return (h, k)
    }
}
