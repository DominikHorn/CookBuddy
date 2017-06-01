//
//  ShoppingViewController.swift
//  CookBuddy
//
//  Created by Dominik Horn on 14.04.17.
//  Copyright © 2017 Dominik Horn. All rights reserved.
//

import UIKit

class ShoppingViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var label: UILabel!
    
    // All custom shopping list items
    lazy var customShoppingListItems: [CustomShoppingListItem] = {
        return Database.shared.getCustomShoppingListItems() ?? [CustomShoppingListItem]()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Reload our table view
        tableView.setEditing(true, animated: true)
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK:- UITableViewDelegate
extension ShoppingViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            print("row: \(indexPath.row)")
            var item = Database.shared.getForcedShoppingListItems()[indexPath.row]
            item.bought = true
        case 1:
            if indexPath.row == customShoppingListItems.count {
                customShoppingListItems[indexPath.row].bought = true
            }
            break
        case 2:
            // TODO
            break
        default:
            // Do nothing
            break
        }
    }
}

// MARK:- UITableViewDataSource
extension ShoppingViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        // Always three sections
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            // TODO properly implement
            let count = Database.shared.getForcedShoppingListItems().count
            
            if count == 0 {
                tableView.isHidden = true
                label.isHidden = false
            } else {
                tableView.isHidden = false
                label.isHidden = true
            }
            
            return count
        case 1:
            return customShoppingListItems.count + 1;
        case 2:
            return 0; // TODO IMPLEMENT
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingListCell") as! ShoppingListCell
        
        // Retrieve dish name for cell
        switch indexPath.section {
        case 0:
            let item = Database.shared.getForcedShoppingListItems()[indexPath.row]
            cell.ingredientTextField.text = item.contents
            break
        case 1:
            if indexPath.row == customShoppingListItems.count {
                // Craft new empty cell TODO
            } else {
                let item = customShoppingListItems[indexPath.row]
                cell.ingredientTextField.text = item.contents
                break
            }
            break
        default:
            cell.ingredientTextField.text = "Something went wrong. Uups"
            return cell // TODO: RETURN ERROR CELL
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ["Benötigt für heute", "Eigene Einträge", "Benötigt diese Woche"][section]
    }
}
