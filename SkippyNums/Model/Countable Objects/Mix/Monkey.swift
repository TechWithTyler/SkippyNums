//
//  Monkey.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 12/11/23.
//  Copyright © 2023-2026 SheftApps. All rights reserved.
//

// MARK: - Imports

import Foundation

struct Monkey: CountableObject {

    // MARK: - Properties - Image/Accessibility

    var name: String {
        return "\(quantity)monkeys"
    }

    let quantity: Int

    // MARK: - Properties - Sound

    let soundFilename: String = "monkey.caf"

    let soundRate: Float = 1.5

    // MARK: - Initialization

    init(quantity: Int) {
        self.quantity = quantity
    }

}
