//
//  Cow.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 12/11/23.
//  Copyright © 2023-2026 SheftApps. All rights reserved.
//

// MARK: - Imports

import Foundation

struct Cow: CountableObject {

    // MARK: - Properties - Image/Accessibility

    let name: String = "cows"

    let quantity: Int

    // MARK: - Properties - Sound

    let soundFilename: String = "moo.caf"

    let soundRate: Float = 2

    // MARK: - Initialization

    init(quantity: Int = 2) {
        self.quantity = quantity
    }

}
