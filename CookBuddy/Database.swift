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
    
    // Globally shared current date (TODO: come up with better data flow)
    var currentDate: Date

    // Whether or not updates have occured on the database since last queried
    private var _updatesOccured: Bool = false
    var updatesOccured: Bool {
        get {
            if _updatesOccured {
                _updatesOccured = false
                return true
            }
            
            return false
        }
        set {
            _updatesOccured = newValue
        }
    }
    
    init() {
        currentDate = Date()
        
        // Copy database to documents if necessary
        let fileManager = FileManager.default
        let bundlePath = Bundle.main.path(forResource: "cookbuddy_test", ofType: "sqlite")!
        let fullDestPath = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!).appendingPathComponent("cookbuddy_test.sqlite").path
        if fileManager.fileExists(atPath: fullDestPath){
            fileManager.fileExists(atPath: bundlePath)
        }else{
            do{
                try fileManager.copyItem(atPath: bundlePath, toPath: fullDestPath)
            }catch{
                print(error)
            }
        }
        
        // Database connection configuration
        var config = Configuration()
        config.readonly = false
        config.foreignKeysEnabled = true // Default is already true
        //config.trace = { print($0) }     // Prints all SQL statements
        
        // Locates database file and opens it
        dbQueue = try? DatabaseQueue(path: fullDestPath, configuration: config)
    }
    
    func getAllDishes() -> [Dish]! {
        var dishes = [Dish]()
        do {
            try dbQueue?.inDatabase { db in
                let rows = try Row.fetchCursor(db, "SELECT * FROM dishes ORDER BY name ASC")
                while let row = try rows.next() {
                    // Fetch scheduled date
                    let dishId: Int = row.value(named: "dishid")
                    let name: String = row.value(named: "name")
                    let imageFileName: String = row.value(named: "imagefile")
                    let description: String = row.value(named: "description")
                    
                    // Query for ingredients
                    let ingredientsRaw = try Row.fetchCursor(db, "SELECT i.* FROM dishes d, contains c, ingredients i WHERE i.ingid = c.ingid and d.dishid = c.dishid and d.dishid = ? ORDER BY i.name ASC", arguments: [dishId])
                    var ingredients = [Ingredient]()
                    while let ingredient = try ingredientsRaw.next() {
                        let ingid: Int = ingredient.value(named: "ingid")
                        let ingName: String = ingredient.value(named: "name")
                        let ingPlural: String? = ingredient.value(named: "plural")
                        ingredients.append(Ingredient(id: ingid, name: ingName, plural: ingPlural))
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
    
    func getShoppingListItems(forDate date: Date) -> [ShoppingListItem]! {
        // Formatter for obtaining string from date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        // Query database
        do {
            var tmpList = [ShoppingListItem]()
            try dbQueue?.inDatabase { db in
                let rows = try Row.fetchCursor(db, "SELECT c.dishid, i.name, i.plural, c.ingid, c.quantity * s.numberOfPeople as quantity, c.unit FROM schedule s, ingredients i, contains c WHERE date(s.scheduledfor) = date(?) and c.dishid = s.dishid and c.ingid = i.ingid ORDER BY name ASC", arguments: [formatter.string(from: date)])
                while let row = try rows.next() {
                    let belongsTo: Int = row.value(named: "dishid")
                    let ingname: String = row.value(named: "name")
                    let ingplural: String? = row.value(named: "plural")
                    let ingid: Int = row.value(named: "ingid")
                    let quantity: Float = row.value(named: "quantity")
                    let unit: String? = row.value(named: "unit")
                    
                    tmpList.append(ShoppingListItem(ingredient: Ingredient(id: ingid, name: ingname, plural: ingplural), quantity: quantity, belongsTo: belongsTo, unit: unit))
                }
            }
            
            // Walk through shopping list items and compress
            var shoppingListItems = [ShoppingListItem]()
            for item in tmpList {
                let existingItemIndex = shoppingListItems.index {i in i.ingredient.id == item.ingredient.id}
                if let itemIndex = existingItemIndex {
                    shoppingListItems[itemIndex].add(quantity: item.quantity)
                } else {
                    shoppingListItems.append(item)
                }
            }
            
            return shoppingListItems
        } catch {
            print("ERROR: Database broken in \(#function)")
            print(error)
        }
        
        return nil
    }
    
    func getScheduled(forDate date: Date) -> [ScheduleEntry]! {
        // Formatter for obtaining string from date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        var scheduledEntries = [ScheduleEntry]()
        do {
            // Fetch scheduled scheduleentries in ascending order for the date
            try dbQueue?.inDatabase { db in
                let rows = try Row.fetchCursor(db, "SELECT * FROM schedule WHERE date(scheduledfor) = date(?) ORDER BY scheduledfor ASC", arguments:[formatter.string(from: date)])
                while let row = try rows.next() {
                    // Fetch scheduled date
                    let scheduledFor: Date = row.value(named: "scheduledfor")
                    let scheduleNumber: Int = row.value(named: "schedulenumber")
                    let numberOfPeople: Int = row.value(named: "numberofpeople")
                    let dishId: Int = row.value(named: "dishid")
                    scheduledEntries.append(ScheduleEntry(scheduledFor: scheduledFor, dishId: dishId, numberOfPeople: numberOfPeople, scheduleNumber: scheduleNumber))
                }
            }
            
            // Return that array
            return scheduledEntries
        } catch {
            // Just print out that an error occured..
            print("ERROR: Database broken in \(#function)")
        }

        return nil
    }
    
    func deleteSchedule(entry: ScheduleEntry) {
        // updates have occured
        updatesOccured = true
        
        do {
            try dbQueue?.inDatabase { db in
                try db.execute("DELETE FROM schedule " +
                               "WHERE scheduledfor = ? and schedulenumber = ?",
                               arguments: [entry.scheduledFor, entry.scheduleNumber])
            }
        } catch {
            // Ignore apart from printing error
            print(error)
        }
    }
    
    // Schedules a dish for a certain date
    func schedule(entry: ScheduleEntry) {        
        // Updates have occured
        updatesOccured = true
        
        // Fetch number of dishes for date
        let count = (getScheduled(forDate: entry.scheduledFor)?.count)!
        
        // Insert into schedule
        do {
            try dbQueue?.inDatabase { db in
                try db.execute(
                    "INSERT INTO schedule (scheduledfor, schedulenumber, numberOfPeople, dishid) " +
                    "VALUES (?, ?, ?, ?)",
                    arguments: [entry.scheduledFor, count, entry.numberOfPeople, entry.dishId])
            }
        } catch {
            // Ignore
        }
    }
    
    // Retrieve dish for id SQL-INJECTION VULNERABLE
    func getDish(forId id: Int) -> Dish! {
        var dish: Dish?
        do {
            try dbQueue?.inDatabase {
                db in
                let rows = try Row.fetchCursor(db, "SELECT * FROM dishes WHERE dishid = ?", arguments: [id])
                while let row = try rows.next() {
                    // Fetch name of dish
                    let name: String = row.value(named: "name")
                    
                    // Fetch and craft description (description text + ingredients list)
                    let description: String = row.value(named: "description")
                    let ingredientsRaw = try Row.fetchCursor(db, "SELECT i.* FROM ingredients i, contains c WHERE c.dishid = ? and c.ingid = i.ingid ORDER BY i.name ASC", arguments: [id])
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
    
    // TODO: this is rather temporary
    func getRandomDishes(amount: Int) -> [Dish] {
        // Obtain id range
        var maxID: Int = 1
        do {
            try dbQueue?.inDatabase {
                db in
                let rows = try Row.fetchCursor(db, "SELECT max(DishID) as max FROM dishes")
                maxID = (try rows.next()?.value(named: "max"))!
            }
        } catch {
            print("ERROR: Database broken in \(#function)")
        }

        // Generate [amount] random indices witin [1, maxId]. Make sure they are actually random
        var tmp = [Int]()
        for i in 1...maxID {
            tmp.append(i)
        }
        
        // Obtain amount many random dishes
        var dishes = [Dish]()
        for _ in 0..<amount {
            let index: Int = Int(arc4random_uniform(UInt32(tmp.count)))
            dishes.append(getDish(forId: tmp[index]))
            tmp.remove(at: index)
        }
        
        // Sort dishes manually
        dishes.sort() { lDish, rDish in
            return lDish.name < rDish.name
        }
        
        return dishes
    }
}
