//
//  Bear.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 12/11/23.
//  Copyright © 2023-2025 SheftApps. All rights reserved.
//

import Foundation

struct Bear: CountableObject {

    var name: String = "bears"

    var quantity: Int

    var soundFilename: String = "bear.caf"

    var soundRate: Float = 2

    init(quantity: Int = 10) {
        self.quantity = quantity
    }

}
