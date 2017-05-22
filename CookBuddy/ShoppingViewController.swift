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

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
}

// MARK:- UITableViewDataSource
extension ShoppingViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        // Always two sections TODO
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            let count = Database.shared.getShoppingListItems(forDate: Date()).count
            
            if count == 0 {
                tableView.isHidden = true
                label.isHidden = false
            } else {
                tableView.isHidden = false
                label.isHidden = true
            }
            
            // Get shopping list items for today
            return count // TODO: handle 0 case and display message that nothing exists for that date
        case 1:
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
            let item = Database.shared.getShoppingListItems(forDate: Date())[indexPath.row]
            cell.ingredientTextField.text = item.description
        case 1:
            break
        default:
            return cell // TODO: RETURN ERROR CELL
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ["Benötigt für heute", "Benötigt diese Woche"][section]
    }
}
