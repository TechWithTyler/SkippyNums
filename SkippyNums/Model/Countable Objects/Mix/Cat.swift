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

    // MARK: - Properties - Image/Accessibility

    var name: String {
        return "\(quantity)cats"
    }

    let quantity: Int

    // MARK: - Properties - Sound

    let soundFilename: String = "meow.caf"

    let soundRate: Float = 1.5

    // MARK: - Initialization

    init(quantity: Int) {
        self.quantity = quantity
    }

}
