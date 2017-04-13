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
        
        try dbQueue?.inDatabase { db in
            let rows = try Row.fetchCursor(db, "SELECT * FROM dishes")
            while let row = try rows.next() {
                let id: Int = row.value(named: "dishid")
                let name: String = row.value(named: "name")
                let description: String = row.value(named: "description")
                let imageName: String = row.value(named: "imagefile")
                dishes.append(Dish(id: id, name: name, description: description, imageName: imageName))
            }
        }
        
        return dishes
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
