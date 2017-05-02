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
        
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK:- Helper
extension ShoppingViewController {
    func prettify(float: Float) -> String {
        if float == float.rounded(.toNearestOrAwayFromZero) {
            // If number is .0, return just integer part
            return String(format: "%d", Int(float))
        } else {
            // Else return pretty fraction
            let num = Int(float)
            let rational = rationalApproximation(of: Double(float - Float(num)))
            
            if num == 0 {
                return String(format: "%d/%d", rational.num, rational.den)
            } else {
                return String(format: "%d %d/%d", num, rational.num, rational.den)
            }
        }
    }
    
    typealias Rational = (num : Int, den : Int)
    
    func rationalApproximation(of x0 : Double, withPrecision eps : Double = 1.0E-6) -> Rational {
        var x = x0
        var a = x.rounded(.down)
        var (h1, k1, h, k) = (1, 0, Int(a), 1)
        
        while x - a > eps * Double(k) * Double(k) {
            x = 1.0/(x - a)
            a = x.rounded(.down)
            (h1, k1, h, k) = (h, k, h1 + Int(a) * h, k1 + Int(a) * k)
        }
        return (h, k)
    }
}

// MARK:- UITableViewDelegate
extension ShoppingViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}

// MARK:- UITableViewDataSource
extension ShoppingViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        // Always two sections
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
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        // Don't highlight any table view cells
        return false
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
            cell.ingredientTextField.text = String(format: "\(prettify(float: item.quantity)) " + (item.unit == nil ? "" : "\(item.unit!) ") + "\(item.ingredient.name)")
        case 1:
            break
            //
        default:
            return cell // TODO: RETURN ERROR CELL
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ["Benötigt für heute", "Benötigt diese Woche"][section]
    }
}
