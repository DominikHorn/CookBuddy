//
//  DishDetailViewController.swift
//  CookBuddy
//
//  Created by Dominik Horn on 17.04.17.
//  Copyright © 2017 Dominik Horn. All rights reserved.
//

import UIKit

class DishDetailViewController: UIViewController {
    @IBOutlet weak var dishTitel: UILabel! {
        didSet {
            dishTitel.text = dish?.name
        }
    }
    @IBOutlet weak var dishDescription: UITextView! {
        didSet {
            dishDescription.text = dish?.description
            if (dish?.ingredients?.count)! > 0 {
                dishDescription.text = dishDescription.text + "\n\nZutaten:"
                for (index, ing) in (dish?.ingredients)!.enumerated() {
                    // TODO: Add ingredient amount
                    dishDescription.text = dishDescription.text + "\n\(index + 1). \(ing.name)"
                }
            }
            
            // Resize according to content
            let fixedWidth = dishDescription.frame.size.width
            dishDescription.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
            let newSize = dishDescription.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
            var newFrame = dishDescription.frame
            newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
            dishDescription.frame = newFrame;

        }
    }
    @IBOutlet weak var dishImage: UIImageView! {
        didSet {
            dishImage.image = dish?.image
        }
    }
    
    // dish to be displayed in detail
    var dish: Dish?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
