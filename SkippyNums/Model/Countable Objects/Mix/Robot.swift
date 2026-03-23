//
//  Robot.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 12/11/23.
//  Copyright © 2023-2026 SheftApps. All rights reserved.
//

// MARK: - Imports

import Foundation

struct Robot: CountableObject {

    // MARK: - Properties - Image/Accessibility

    var name: String {
        return "\(quantity)robots"
    }

    let quantity: Int

    // MARK: - Properties - Sound

    let soundFilename: String = "robot.caf"

    let soundRate: Float = 1.5

    // MARK: - Initialization

    init(quantity: Int) {
        self.quantity = quantity
    }

}
