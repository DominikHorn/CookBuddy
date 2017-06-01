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
        print("DB Path: \(fullDestPath)")
        
        // Execute this statement to allow foreign key constraints/triggers
        // Otherwise foreign key constraints will be ignored.. ty sqlite3
        dbQueue?.inDatabase { db in
            try! db.execute("PRAGMA foreign_keys = ON");
        }
    }
    
    // MARK:-- Dish handeling
    func getAllDishes() -> [Dish]! {
        var dishes = [Dish]()
        do {
            try dbQueue?.inDatabase { db in
                let rows = try Row.fetchCursor(db, "SELECT * FROM dishes ORDER BY name ASC")
                while let row = try rows.next() {
                    // Fetch scheduled date
                    let dishId: Int = row.value(named: "id")
                    let name: String = row.value(named: "name")
                    let imageFileName: String = row.value(named: "imagefile")
                    let description: String = row.value(named: "description")
                    
                    // Query for ingredients
                    let ingredientsRaw = try Row.fetchCursor(db, "SELECT i.* FROM dishes d, contains c, ingredients i WHERE i.id = c.ingid and d.id = c.dishid and d.id = ? ORDER BY i.name ASC", arguments: [dishId])
                    var ingredients = [Ingredient]()
                    while let ingredient = try ingredientsRaw.next() {
                        let ingid: Int = ingredient.value(named: "id")
                        let ingName: String = ingredient.value(named: "name")
                        let ingPlural: String? = ingredient.value(named: "plural")
                        ingredients.append(Ingredient(id: ingid, name: ingName, plural: ingPlural))
                    }
                    
                    dishes.append(Dish(id: dishId, name: name, ingredients: ingredients, description: description, imageName: imageFileName))
                }
            }
            
            return dishes
        } catch {
            _handleDBError(error: error)
        }
        
        return nil
    }
    
    // Retrieve dish for id
    func getDish(forId id: Int) -> Dish! {
        var dish: Dish?
        do {
            try dbQueue?.inDatabase {
                db in
                let rows = try Row.fetchCursor(db, "SELECT * FROM dishes WHERE id = ?", arguments: [id])
                while let row = try rows.next() {
                    // Fetch name of dish
                    let name: String = row.value(named: "name")
                    
                    // Fetch and craft description (description text + ingredients list)
                    let description: String = row.value(named: "description")
                    let ingredientsRaw = try Row.fetchCursor(db, "SELECT i.* FROM ingredients i, contains c WHERE c.dishid = ? and c.ingid = id ORDER BY i.name ASC", arguments: [id])
                    var ingredients = [Ingredient]()
                    while let ingredient = try ingredientsRaw.next() {
                        let ingid: Int = ingredient.value(named: "id")
                        let ingName: String = ingredient.value(named: "name")
                        ingredients.append(Ingredient(id: ingid, name: ingName))
                    }
                    
                    // Fetch image name
                    let imageName: String = row.value(named: "imagefile")
                    dish = Dish(id: id, name: name, ingredients: ingredients, description: description, imageName: imageName)
                }
            }
        } catch {
            _handleDBError(error: error)
        }
        
        return dish
    }
    
    // TODO: this is rather temporary
    func getRandomDishes(amount: Int) -> [Dish]! {
        // Obtain id range
        var maxID: Int = 1
        do {
            try dbQueue?.inDatabase { db in
                //TODO use sql count()
                let rows = try Row.fetchCursor(db, "SELECT max(id) as max FROM dishes")
                maxID = (try rows.next()?.value(named: "max"))!
            }
        } catch {
            _handleDBError(error: error)
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
    
    // MARK:-- Schedule handeling
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
                    let id: Int = row.value(named: "id")
                    let scheduledFor: Date = row.value(named: "scheduledfor")
                    let numberOfPeople: Int = row.value(named: "numberofpeople")
                    let dishId: Int = row.value(named: "dishid")
                    scheduledEntries.append(ScheduleEntry(id: id, dishId: dishId, scheduledFor: scheduledFor, numberOfPeople: numberOfPeople))
                }
            }
            
            // Return that array
            return scheduledEntries
        } catch {
            _handleDBError(error: error)
        }
        
        return nil
    }
    
    func deleteSchedule(entry: ScheduleEntry) {
        // updates have occured
        updatesOccured = true
        
        do {
            try dbQueue?.inDatabase { db in
                try db.execute("DELETE FROM schedule " +
                    "WHERE id = ?",
                               arguments: [entry.id])
            }
        } catch {
            _handleDBError(error: error)
        }
    }
    
    // Schedules a dish for a certain date
    func schedule(dishId id: Int, for scheduledFor: Date, withNumberOfPeople numberOfPeople: Int = 3) {
        // Updates have occured
        updatesOccured = true
        
        // Needed for query down bellow
        var scheduleID: Int = 0
        
        // Insert into schedule
        do {
            try dbQueue?.inDatabase { db in
                try db.execute(
                    "INSERT INTO schedule (dishid, scheduledfor, numberOfPeople) " +
                    "VALUES (?, ?, ?)",
                    arguments: [id, scheduledFor, numberOfPeople])
                scheduleID = try (Row.fetchCursor(db, "SELECT last_insert_rowid() as rowid").next()?.value(named: "rowid"))!
            }
        } catch {
            _handleDBError(error: error)
        }
        
        // Schedule forcedShoppingItems
        // Do queries this way since inDatabase block is not reentrant
        if let dish = getDish(forId: id) {
            do {
                try dbQueue?.inDatabase { db in
                    // Iterate over ingredients, merging into existing scheduled for the same date
                    for ingredient in dish.ingredients! {
                        // Fetch autoincremented id (TODO: research better way to achieve this)
                        try db.execute("INSERT INTO forcedshoppingitems(ingid, bought, scheduleid) VALUES (?, 'FALSE', ?)", arguments: [ingredient.id, scheduleID])
                    }
                }
            } catch {
                _handleDBError(error: error)
            }
        }
    }
    
    // MARK:-- Shopping list handeling
    func update(customShoppingListItem item: CustomShoppingListItem) {
        // Update in customShoppingListItem table
        do {
            try dbQueue?.inDatabase { db in
                // execute update statement on the table
                try db.execute("UPDATE customShoppingItems SET string=?, bought=? WHERE id=?", arguments: [item.contents, item.bought, item.id])
            }
        } catch {
            _handleDBError(error: error)
        }
    }
    
    func update(forcedShoppingListItem item: ForcedShoppingListItem) {
        // TODO: this might be incomplete since we're only updating the bought value
        // Update in customShoppingListItem table
        do {
            try dbQueue?.inDatabase { db in
                // execute update statement on the table
                try db.execute("UPDATE forcedshoppingitems SET bought=? WHERE id=?", arguments: [item.bought, item.id])
            }
        } catch {
            _handleDBError(error: error)
        }
    }
    
    func getCustomShoppingListItems(onlyNotBought: Bool = true) -> [CustomShoppingListItem]! {
        var list = [CustomShoppingListItem]()
        
        // fetch from database
        do {
            try dbQueue?.inDatabase { db in
                // Fetch all rows from customShoppingListItems
                let rows = try Row.fetchCursor(db, "SELECT c.* FROM customshoppingitems c \(onlyNotBought ? "WHERE c.bought = 'FALSE'" : "")")
                while let row = try rows.next() {
                    list.append(CustomShoppingListItem(id: row.value(named: "id"), bought: row.value(named: "bought"), initialContents: row.value(named: "string")))
                }
            }
        } catch {
            _handleDBError(error: error)
        }
        
        return list
    }
    
    func getForcedShoppingListItems(onlyToday: Bool = false, onlyNotBought: Bool = true) -> [ForcedShoppingListItem]! {
        var list = [ForcedShoppingListItem]()
        
        // fetch from database
        do {
            try dbQueue?.inDatabase { db in
                // Fetch all rows from customShoppingListItems
                let rows = try Row.fetchCursor(db, "SELECT f.* FROM forcedshoppingitems f, schedule sch WHERE \(onlyNotBought ? "f.bought = 'FALSE' AND" : "") f.scheduleid = sch.id AND \(onlyToday ? "date(sch.scheduledfor) == date('now')" :"date(sch.scheduledfor) >= date('now') AND date(sch.scheduledfor) < date('now', '+7 day')")")
                while let row = try rows.next() {
                    list.append(ForcedShoppingListItem(id: row.value(named: "id"), ingId: row.value(named: "ingid"), scheduleId: row.value(named: "scheduleid"), bought: row.value(named: "bought")))
                }
            }
        } catch {
            _handleDBError(error: error)
        }
        
        return list
    }
    
    func getContents(forForcedShoppingListItem item: ForcedShoppingListItem) -> (quantity: Float, ingredient: Ingredient, unit: Unit?)? {
        var tuple: (Float, Ingredient, Unit?)? = nil
        do {
            try dbQueue?.inDatabase { db in
                if let row = try Row.fetchOne(db, "SELECT c.quantity as quantity, i.id as ingid, i.name as name, i.plural as plural "
                    + "FROM contains c, schedule s, forcedshoppingitems f, ingredients i "
                    + "WHERE c.ingid = f.ingid AND c.dishid = s.dishid AND f.scheduleid = s.id AND f.ingid = i.id AND f.id = ?",
                                              arguments: [item.id]) {
                    
                    // Fetch all values
                    let quantity: Float = row.value(named: "quantity")
                    let ingredient = Ingredient(id: row.value(named: "ingid"), name: row.value(named: "name"), plural: row.value(named: "plural"))
                    var unit: Unit? = nil
                    
                    if let row = try Row.fetchOne(db, "SELECT u.id as id, u.name as name, u.plural as plural FROM units u, contains c, schedule s, forcedshoppingitems f WHERE u.id = c.unitid AND c.ingid = f.ingid AND c.dishid = s.dishid AND s.id = f.scheduleid AND f.id = ?",
                                                  arguments: [item.id]) {
                        unit = Unit(id: row.value(named: "id"), name: row.value(named: "name"), plural: row.value(named: "plural"))
                    }
                                        
                    // Return that tuple
                    tuple = (quantity, ingredient, unit)
                }
            }
        } catch {
            _handleDBError(error: error)
        }
        
        return tuple
    }
    

    // MARK:-- handlers
    func _handleDBError(error: Error) {
        // Just print out that an error occured..
        print("ERROR: Database broken in \(#function)")
        print(error)
    }
}
