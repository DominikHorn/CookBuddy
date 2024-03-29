//
//  EventTableViewCell.swift
//  CookBuddy
//
//  Created by Dominik Horn on 15.04.17.
//  Copyright © 2017 Dominik Horn. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    @IBOutlet weak var dishImageView: UIImageView! {
        didSet {
            dishImageView.image = UIImage(contentsOfFile: Bundle.main.path(forResource: "doener", ofType: "jpg", inDirectory: "DishImages")!)
        }
    }
    
    @IBOutlet weak var dishTitelLabel: UILabel! {
        didSet {
            dishTitelLabel.text = "Spinatklösse"
        }
    }
    
    @IBOutlet weak var scheduleTimeLabel: UILabel! {
        didSet {
            scheduleTimeLabel.text = "12:00"
        }
    }
}
