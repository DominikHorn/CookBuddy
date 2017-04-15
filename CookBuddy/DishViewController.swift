//
//  ViewController.swift
//  CookBuddy
//
//  Created by Dominik Horn on 11.04.17.
//  Copyright © 2017 Dominik Horn. All rights reserved.
//

import UIKit

class DishViewController: UIViewController {
    @IBOutlet weak var dishTitel: UILabel!
    @IBOutlet weak var dishDescription: UITextView!
    @IBOutlet weak var dishImage: UIImageView!
    
    // TODO: temporary
    var numberPool = [Int]()
    
    @IBAction func fetchNextDish(sender: UIButton?) {
        // obtain dishes
        let dishes = try! Database.shared.getDishes() // TODO
        
        // choose next dish TODO: temporary
        if numberPool.isEmpty {
            for i in 0..<dishes.count {
                numberPool.append(i)
            }
        }
        let nextNumberIndex = Int(arc4random_uniform(UInt32(numberPool.count)))
        let dish = dishes[numberPool.remove(at: nextNumberIndex)]
        
        // Update UI
        self.dishTitel?.text = dish.name
        self.dishDescription?.text = dish.description
        self.dishImage?.image = dish.image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetch initial dish
        self.fetchNextDish(sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
