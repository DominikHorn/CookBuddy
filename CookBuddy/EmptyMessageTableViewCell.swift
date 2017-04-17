//
//  EmptyMessageTableViewCell.swift
//  CookBuddy
//
//  Created by Dominik Horn on 17.04.17.
//  Copyright © 2017 Dominik Horn. All rights reserved.
//

import UIKit

class EmptyMessageTableViewCell: UITableViewCell {
    @IBOutlet weak var messageLabel: UILabel! {
        didSet {
            messageLabel.text = "Keine Gerichte für heute geplant"
        }
    }
}
