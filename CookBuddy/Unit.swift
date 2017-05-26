//
//  Unit.swift
//  CookBuddy
//
//  Created by Dominik Horn on 22.05.17.
//  Copyright © 2017 Dominik Horn. All rights reserved.
//

import Foundation

struct Unit {
    let id: Int
    let name: String
    let plural: String?

    init(id: Int, name: String, plural: String? = nil) {
        self.id = id
        self.name = name
        self.plural = plural
    }
}
