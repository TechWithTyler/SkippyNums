//
//  Elephant.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 12/11/23.
//  Copyright © 2023-2025 SheftApps. All rights reserved.
//

import Foundation

struct Elephant: CountableObject {

    var name: String = "elephants"

    var quantity: Int

    var soundFilename: String = "elephantTrumpet.caf"

    var soundRate: Float = 2.5

    init(quantity: Int = 2) {
        self.quantity = quantity
    }

}
