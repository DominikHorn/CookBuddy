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
    
    // temporary for testing
    func getDishes() throws -> [Dish] {
        var dishes = [Dish]()
        
        // Fetch dishes from sqlite
        try dbQueue?.inDatabase { db in
            let rows = try Row.fetchCursor(db, "SELECT * FROM dishes")
            while let row = try rows.next() {
                // Fetch dish id
                let id: Int = row.value(named: "dishid")
                
                // Fetch name of dish
                let name: String = row.value(named: "name")
                
                // Fetch and craft description (description text + ingredients list)
                var description: String = row.value(named: "description") + "\n\nEnthält folgende Zutaten:"
                let ingredients = try Row.fetchCursor(db, "SELECT i.* FROM ingredients i, contains c WHERE c.dishid = \(id) and c.ingid = i.ingid")
                var counter = 0
                while let ingredient = try ingredients.next() {
                    counter += 1
                    description += "\n\(counter). " + ingredient.value(named: "name")
                }
                
                // Fetch image name
                let imageName: String = row.value(named: "imagefile")
                dishes.append(Dish(id: id, name: name, description: description, imageName: imageName))
            }
        }
        
        return dishes
    }
    
    func numberOfDishesScheduled(forDate date: Date) throws -> Int {
        // Counter of dishes
        var counter = 0
        
        // Fetch scheduled dishes from sqlite
        try dbQueue?.inDatabase { db in
            let rows = try Row.fetchCursor(db, "SELECT * FROM schedule")
            while let row = try rows.next() {
                // Fetch scheduled date
                let fetchedDate: Date = row.value(named: "scheduledfor")
                if date.isOnSameDayAs(date: fetchedDate) {
                    counter += 1
                }
            }
        }
        
        return counter
    }
    
    // Dish class encapsulates a single dish
    class Dish {
        let id: Int
        let name: String
        let description: String?
        let image: UIImage?
        
        init(id: Int, name: String, description: String? = nil, imageName: String? = nil) {
            self.id = id
            self.name = name
            self.description = description
            self.image = UIImage(contentsOfFile: Bundle.main.path(forResource: imageName, ofType: "jpg", inDirectory: "DishImages")!)
        }
    }
}
