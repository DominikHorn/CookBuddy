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
    
    func getScheduled(forDate date: Date) -> [ScheduleEntry]? {
        var scheduledEntries = [ScheduleEntry]()
        
        // TODO: Unify in one sql statement
        do {
            // Fetch scheduled dishes (by id) from sqlite
            try dbQueue?.inDatabase { db in
                let rows = try Row.fetchCursor(db, "SELECT * FROM schedule")
                while let row = try rows.next() {
                    // Fetch scheduled date
                    let scheduledFor: Date = row.value(named: "scheduledfor")
                    let scheduleNumber: Int = row.value(named: "schedulenumber")
                    let numberOfPeople: Int = row.value(named: "numberofpeople")
                    let dishId: Int = row.value(named: "dishid")
                    if date.isOnSameDayAs(date: scheduledFor) {
                        scheduledEntries.append(ScheduleEntry(scheduledFor: scheduledFor, dishId: dishId, numberOfPeople: numberOfPeople, scheduleNumber: scheduleNumber))
                    }
                }
            }
            
            // Sort scheduled entries based on timestamp
            scheduledEntries = scheduledEntries.sorted {
                first, second in
                return first.scheduledFor < second.scheduledFor
            }
            
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
        print(entry)
        
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
