//
//  Monkey.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 12/11/23.
//  Copyright © 2023-2025 SheftApps. All rights reserved.
//

import Foundation

struct Monkey: CountableObject {

    var name: String {
        return "\(quantity)monkeys"
    }

    var quantity: Int

    var soundFilename: String = "monkey.caf"

    var soundRate: Float = 1.5

    init(quantity: Int) {
        self.quantity = quantity
    }

}
