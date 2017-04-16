//
//  ViewController.swift
//  CookBuddy
//
//  Created by Dominik Horn on 11.04.17.
//  Copyright © 2017 Dominik Horn. All rights reserved.
//

import UIKit

class GenerateDishViewController: UIViewController {
    @IBOutlet weak var dishTitel: UILabel!
    @IBOutlet weak var dishDescription: UITextView!
    @IBOutlet weak var dishImage: UIImageView!
    
    // TODO: temporary
    var numberPool = [Int]()
    var currentSeque: UIStoryboardSegue?
    var date: Date?
    var currentDish: Dish?
    
    @IBAction func fetchNextDish(sender: UIButton?) {        
        let dishes = Database.shared.getAllDishes()
        
        if numberPool.isEmpty {
            for i in 0..<(dishes?.count)! {
                numberPool.append(i)
            }
        }
        
        let nextNumberIndex = Int(arc4random_uniform(UInt32(numberPool.count)))
        self.currentDish = dishes?[numberPool.remove(at: nextNumberIndex)]
        
        // Update UI
        self.dishTitel?.text = self.currentDish?.name
        self.dishDescription?.text = self.currentDish?.description
        self.dishImage?.image = self.currentDish?.image
    }
    
    @IBOutlet weak var confirmButton: UIButton! {
        didSet {
            let image = UIImage(named: "circletick")?.withRenderingMode(.alwaysTemplate)
            self.confirmButton.setImage(image, for: .normal)
            // self.confirmButton.tintColor = UIColor.blue
            // self.confirmButton.setImage(UIImage(emoji: "✔︎\u{20DD}").withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
    @IBAction func confirmChoice(sender: UIButton!) {
        // Schedule dish with database
        Database.shared.schedule(dish: self.currentDish!, forDate: self.date!)
        
        // Pop back to pervious view
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var abortButton: UIButton! {
        didSet {
            let image = UIImage(named: "circlecross")?.withRenderingMode(.alwaysTemplate)
            self.abortButton.setImage(image, for: .normal)
            // self.abortButton.tintColor = UIColor.blue
            // self.abortButton.setImage(UIImage(emoji: "✘\u{20DD}"), for: .normal)
        }
    }
    @IBAction func abortChoice(sender: UIButton!) {
        // Simply pop back
        self.navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.currentSeque = segue
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
