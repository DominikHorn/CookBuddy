//
//  ChooseDishViewcontroller.swift
//  CookBuddy
//
//  Created by Dominik Horn on 18.05.17.
//  Copyright © 2017 Dominik Horn. All rights reserved.
//

import UIKit

class ChooseDishViewcontroller: UIViewController {
    fileprivate var dishes = [Dish]()
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            // Set table view default row height to a value
            tableView.rowHeight = 100
            
            // Hide empty trailing cells
            tableView.tableFooterView = UIView()
        }
    }
    
    func add(dishes: [Dish]) {
        // Insert dishes
        dishes.forEach() {
            [unowned self] d in
            if !self.dishes.contains(d) {
                self.dishes.append(d)
            }
        }
        
        // Force tableview to reload
        tableView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ChooseDishViewcontroller: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let dishDetailView = (self.storyboard?.instantiateViewController(withIdentifier: "DishDetail")) as! DishDetailViewController
        dishDetailView.dish = dishes[indexPath.row]
        self.show(dishDetailView, sender: self)
    }
}

extension ChooseDishViewcontroller: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DishTableCell") as! DishTableViewCell
        
        // Current dish
        let d = dishes[indexPath.row]
        
        cell.dishImage?.image = d.image
        cell.label.text = d.name

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dishes.count
    }
}
