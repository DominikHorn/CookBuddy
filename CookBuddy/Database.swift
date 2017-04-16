//
//  Database.swift
//  CookBuddy
//
//  Created by Dominik Horn on 13.04.17.
//  Copyright © 2017 Dominik Horn. All rights reserved.
//

import UIKit
import GRDB

class Database {
    private let dbQueue: DatabaseQueue?
    static let shared: Database = {
        let instance = Database()
        
        // setup code if necessary at some point
        
        return instance
    }()
    
    init() {
        // Database connection configuration
        var config = Configuration()
        config.readonly = true
        config.foreignKeysEnabled = true // Default is already true
        //        config.trace = { print($0) }     // Prints all SQL statements
        
        // Locates database file and opens it
        let dbPath = Bundle.main.path(forResource: "cookbuddy_test", ofType: "sqlite")!
        self.dbQueue = try? DatabaseQueue(path: dbPath, configuration: config)
    }
    
    func getDishesScheduled(forDate date: Date) -> [Dish]? {
        var ids = [Int]()
        
        do {
            // Fetch scheduled dishes (by id) from sqlite
            try dbQueue?.inDatabase { db in
                let rows = try Row.fetchCursor(db, "SELECT * FROM schedule")
                while let row = try rows.next() {
                    // Fetch scheduled date
                    let fetchedDate: Date = row.value(named: "scheduledfor")
                    let dishId: Int = row.value(named: "dishid")
                    if date.isOnSameDayAs(date: fetchedDate) {
                        ids.append(dishId)
                    }
                }
            }
            // Walk database again, this time extracting actual dishes. TODO: rework into one sqlite queue. For this, look up date comparison in sql
            // This code will eventually be replaced with a cloud kit model, meaning it will be thrown out anyways
            var dishes = [Dish]()
            for dishid in ids {
                if let dish = getDish(forId: dishid) {
                    dishes.append(dish)
                }
            }
            return dishes
        } catch {
            // Just print out that an error occured..
            print("ERROR: Database broken in \(#function)")
        }

        return nil
    }
    
    // Retrieve dish for id
    func getDish(forId id: Int) -> Dish? {
        var dish: Dish?
        do {
            try dbQueue?.inDatabase {
                db in
                let rows = try Row.fetchCursor(db, "SELECT * FROM dishes WHERE dishid = '\(id)';")
                while let row = try rows.next() {
                    // Fetch name of dish
                    let name: String = row.value(named: "name")
                    
                    // Fetch and craft description (description text + ingredients list)
                    let description: String = row.value(named: "description")
                    let ingredientsRaw = try Row.fetchCursor(db, "SELECT i.* FROM ingredients i, contains c WHERE c.dishid = \(id) and c.ingid = i.ingid;")
                    var ingredients = [String]()
                    while let ingredient = try ingredientsRaw.next() {
                        ingredients.append(ingredient.value(named: "name"))
                    }
                    
                    // Fetch image name
                    let imageName: String = row.value(named: "imagefile")
                    dish = Dish(id: id, name: name, ingredients: ingredients, description: description, imageName: imageName)
                }
            }
        } catch {
            // Just print out that an error occured..
            print("ERROR: Database broken in \(#function)")
        }
        
        return dish
    }
}
