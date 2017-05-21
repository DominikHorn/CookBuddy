//
//  ChooseDishViewcontroller.swift
//  CookBuddy
//
//  Created by Dominik Horn on 18.05.17.
//  Copyright © 2017 Dominik Horn. All rights reserved.
//

import UIKit

class ChooseDishViewController: UIViewController {
    fileprivate var dishes = [Dish]()
    fileprivate var filteredDishes = [Dish]()
    
    // Search controller
    let searchController = UISearchController(searchResultsController: nil)

    
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
        
        // filter dishes if a filter string is present
        filterData()
        
        // Force tableview to reload
        tableView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.definesPresentationContext = true
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Fix annoying console warning
    deinit {
        self.searchController.view.removeFromSuperview()
    }
}

extension ChooseDishViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Load and configure dish detail view
        let dishDetailView = (storyboard?.instantiateViewController(withIdentifier: "DishDetail")) as! DishDetailViewController
        dishDetailView.dish = shouldFilter() ? filteredDishes[indexPath.row] : dishes[indexPath.row]
        dishDetailView.canAdd = true
        
        show(dishDetailView, sender: self)
    }
}

extension ChooseDishViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DishTableCell") as! DishTableViewCell
        
        // Current dish
        var d: Dish
        if shouldFilter() {
            d = filteredDishes[indexPath.row]
        } else {
            d = dishes[indexPath.row]
        }
        
        cell.dishImage?.image = d.image
        cell.label.text = d.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldFilter() {
            return filteredDishes.count
        }
        
        return dishes.count
    }
}

// MARK:-- Search bar filtering
extension ChooseDishViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterData()
        tableView.reloadData()
    }
    
    func shouldFilter() -> Bool {
        return searchController.isActive && searchController.searchBar.text != ""
    }
    
    func filterData() {
        if shouldFilter() {
            filteredDishes = dishes.filter { dish in
                return dish.name.lowercased().contains((searchController.searchBar.text?.lowercased())!)
            }
        }
    }
}
