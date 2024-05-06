//
//  Dog.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 3/12/24.
//  Copyright © 2023-2024 SheftApps. All rights reserved.
//

import Foundation

struct Dog: CountableObject {

    var name: String {
        return "\(quantity)dogs"
    }

    var quantity: Int

    var soundFilename: String = "bark.caf"

    var soundRate: Float = 1

    init(quantity: Int) {
        self.quantity = quantity
    }

}
