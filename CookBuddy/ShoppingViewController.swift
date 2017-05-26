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
        
        // Reload our table view
        tableView.setEditing(true, animated: true)
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Mark all items as bought that we selected
        tableView.indexPathsForSelectedRows?.forEach { [unowned self] ip in
            switch ip.section {
            case 0:
                // TODO
                print()
            case 1:
                // TODO
                print()
                // self.customItems[ip.row].bought = true
            case 2:
                // TODO
                print()
            default:
                print("Unknown section \(ip.section)")
            }
        }
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
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
            return 0; // TODO IMPLEMENT
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
            break
        default:
            return cell // TODO: RETURN ERROR CELL
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ["Benötigt für heute", "Eigene Einträge", "Benötigt diese Woche"][section]
    }
}
