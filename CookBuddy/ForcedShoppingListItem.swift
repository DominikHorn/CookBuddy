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
        if let tuple = Database.shared.getContents(forForcedShoppingListItem: self) {
            let nameString: String = (tuple.quantity > 1 && tuple.unit == nil ? ("\(tuple.ingredient.plural ?? tuple.ingredient.name)") : "\(tuple.ingredient.name)")
            var unitString = ""
            if let un = tuple.unit?.name {
                unitString = tuple.quantity > 1 ? "\(tuple.unit?.plural ?? un) " : "\(un) "
            }
            return String(format: "\(prettify(tuple.quantity)) " + unitString + nameString)
        }
        return "Fatal error has occured"
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
    
    init(id: Int, ingId: Int, scheduleId: Int, bought: Bool = false) {
        self.id = id
        self.scheduleId = scheduleId
        self.bought = bought
        self.ingId = ingId
    }
}
