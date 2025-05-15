//
//  Cat.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 3/8/24.
//  Copyright © 2023-2025 SheftApps. All rights reserved.
//

import Foundation

struct Cat: CountableObject {

    var name: String {
        return "\(quantity)cats"
    }

    var quantity: Int

    var soundFilename: String = "meow.caf"

    var soundRate: Float = 1.5

    init(quantity: Int) {
        self.quantity = quantity
    }

}
