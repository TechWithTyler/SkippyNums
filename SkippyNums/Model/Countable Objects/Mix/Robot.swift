//
//  Robot.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 12/11/23.
//  Copyright © 2023-2025 SheftApps. All rights reserved.
//

import Foundation

struct Robot: CountableObject {

    var name: String {
        return "\(quantity)robots"
    }

    let quantity: Int

    let soundFilename: String = "robot.caf"

    let soundRate: Float = 1.5

    init(quantity: Int) {
        self.quantity = quantity
    }

}
