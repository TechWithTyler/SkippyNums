//
//  Cow.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 12/11/23.
//  Copyright © 2023-2025 SheftApps. All rights reserved.
//

// MARK: - Imports

import Foundation

struct Cow: CountableObject {
    
    let name: String = "cows"

    let quantity: Int

    let soundFilename: String = "moo.caf"

    let soundRate: Float = 2

    init(quantity: Int = 2) {
        self.quantity = quantity
    }

}
