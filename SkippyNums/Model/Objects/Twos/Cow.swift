//
//  Cow.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 12/11/23.
//  Copyright © 2023-2025 SheftApps. All rights reserved.
//

import Foundation

struct Cow: CountableObject {
    
    var name: String = "cows"

    var quantity: Int

    var soundFilename: String = "moo.caf"

    var soundRate: Float = 2

    init(quantity: Int = 2) {
        self.quantity = quantity
    }

}
