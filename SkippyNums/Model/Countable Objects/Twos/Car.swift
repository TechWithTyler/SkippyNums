//
//  Car.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 12/11/23.
//  Copyright © 2023-2025 SheftApps. All rights reserved.
//

// MARK: - Imports

import Foundation

struct Car: CountableObject {

    // MARK: - Properties - Image/Accessibility

    let name: String = "cars"

    let quantity: Int

    // MARK: - Properties - Sound

    let soundFilename: String = "carHorn.caf"

    let soundRate: Float = 2.5

    // MARK: - Initialization

    init(quantity: Int = 2) {
        self.quantity = quantity
    }

}
