//
//  Bird.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 12/11/23.
//  Copyright © 2023-2025 SheftApps. All rights reserved.
//

// MARK: - Imports

import Foundation

struct Bird: CountableObject {

    // MARK: - Properties - Image/Accessibility

    var name: String {
        return "\(quantity)birds"
    }

    let quantity: Int

    // MARK: - Properties - Sound

    let soundFilename: String = "bird.caf"

    let soundRate: Float = 1

    // MARK: - Initialization

    init(quantity: Int) {
        self.quantity = quantity
    }

}
