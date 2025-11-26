//
//  Dog.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 3/12/24.
//  Copyright © 2023-2025 SheftApps. All rights reserved.
//

// MARK: - Imports

import Foundation

struct Dog: CountableObject {

    // MARK: - Properties - Image/Accessibility

    var name: String {
        return "\(quantity)dogs"
    }

    let quantity: Int

    // MARK: - Properties - Sound

    let soundFilename: String = "bark.caf"

    let soundRate: Float = 1

    // MARK: - Initialization

    init(quantity: Int) {
        self.quantity = quantity
    }

}
