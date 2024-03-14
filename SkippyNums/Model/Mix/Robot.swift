//
//  Robot.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 12/11/23.
//  Copyright © 2023-2024 SheftApps. All rights reserved.
//

import Foundation

struct Robot: CountableObject {

    var name: String {
        return "\(quantity)robots"
    }

    var quantity: Int

    var soundFilename: String = "robot.caf"

    var soundRate: Float = 1.5

}
