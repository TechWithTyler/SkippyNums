//
//  Bear.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 12/11/23.
//  Copyright © 2023-2026 SheftApps. All rights reserved.
//

// MARK: - Imports

import Foundation

struct Bear: CountableObject {

    // MARK: - Properties - Image/Accessibility

    let name: String = "bears"

    let quantity: Int

    // MARK: - Properties - Sound

    let soundFilename: String = "bear.caf"

    let soundRate: Float = 2

    // MARK: - Initialization

    init(quantity: Int = 10) {
        self.quantity = quantity
    }

}
