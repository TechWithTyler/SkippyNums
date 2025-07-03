//
//  Bear.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 12/11/23.
//  Copyright © 2023-2025 SheftApps. All rights reserved.
//

import Foundation

struct Bear: CountableObject {

    let name: String = "bears"

    let quantity: Int

    let soundFilename: String = "bear.caf"

    let soundRate: Float = 2

    init(quantity: Int = 10) {
        self.quantity = quantity
    }

}
