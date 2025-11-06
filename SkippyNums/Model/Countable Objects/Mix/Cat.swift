//
//  Cat.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 3/8/24.
//  Copyright © 2023-2025 SheftApps. All rights reserved.
//

// MARK: - Imports

import Foundation

struct Cat: CountableObject {

    var name: String {
        return "\(quantity)cats"
    }

    let quantity: Int

    let soundFilename: String = "meow.caf"

    let soundRate: Float = 1.5

    init(quantity: Int) {
        self.quantity = quantity
    }

}
