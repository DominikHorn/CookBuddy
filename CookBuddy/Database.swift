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

    // Whether or not updates have occured on the database since last queried
    private var _updatesOccured: Bool = false
    var updatesOccured: Bool {
        get {
            if self._updatesOccured {
                self._updatesOccured = false
                return true
            }
            
            return false
        }
        set {
            self._updatesOccured = newValue
        }
    }
    
    init() {
        // Database connection configuration
        var config = Configuration()
        config.readonly = false
        config.foreignKeysEnabled = true // Default is already true
        //config.trace = { print($0) }     // Prints all SQL statements
        
        // Locates database file and opens it
        let dbPath = Bundle.main.path(forResource: "cookbuddy_test", ofType: "sqlite")!
        self.dbQueue = try? DatabaseQueue(path: dbPath, configuration: config)
    }
    
    func getAllDishes() -> [Dish]? {
        var dishes = [Dish]()
        do {
            try dbQueue?.inDatabase { db in
                let rows = try Row.fetchCursor(db, "SELECT * FROM dishes")
                while let row = try rows.next() {
                    // Fetch scheduled date
                    let dishId: Int = row.value(named: "dishid")
                    let name: String = row.value(named: "name")
                    let imageFileName: String = row.value(named: "imagefile")
                    let description: String = row.value(named: "description")
                    
                    // Query for ingredients
                    let ingredientsRaw = try Row.fetchCursor(db, "SELECT i.* FROM dishes d, contains c, ingredients i WHERE i.ingid =c.ingid and d.dishid = c.dishid and d.dishid = \(dishId)")
                    var ingredients = [Ingredient]()
                    while let ingredient = try ingredientsRaw.next() {
                        let ingid: Int = ingredient.value(named: "ingid")
                        let ingName: String = ingredient.value(named: "name")
                        ingredients.append(Ingredient(id: ingid, name: ingName))
                    }
                    
                    dishes.append(Dish(id: dishId, name: name, ingredients: ingredients, description: description, imageName: imageFileName))
                }
            }
            
            return dishes
        } catch {
            // Just print out that an error occured..
            print("ERROR: Database broken in \(#function)")
        }
        
        return nil
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
    
    // Schedules a dish for a certain date
    func schedule(dish: Dish, forDate date: Date) {
        // Updates have occured
        self.updatesOccured = true
        
        // Fetch number of dishes for date
        let count = (self.getDishesScheduled(forDate: date)?.count)!
        
        // Insert into schedule
        do {
            try dbQueue?.inDatabase { db in
                try db.execute(
                    "INSERT INTO schedule (scheduledfor, schedulenumber, dishid) " +
                    "VALUES (?, ?, ?)",
                    arguments: [date, count, dish.id])
            }
        } catch {
            // Ignore
        }
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
                    var ingredients = [Ingredient]()
                    while let ingredient = try ingredientsRaw.next() {
                        let ingid: Int = ingredient.value(named: "ingid")
                        let ingName: String = ingredient.value(named: "name")
                        ingredients.append(Ingredient(id: ingid, name: ingName))
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
