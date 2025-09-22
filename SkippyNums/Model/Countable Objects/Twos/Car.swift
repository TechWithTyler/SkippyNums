//
//  Car.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 12/11/23.
//  Copyright © 2023-2025 SheftApps. All rights reserved.
//

import Foundation

struct Car: CountableObject {

    let name: String = "cars"

    let quantity: Int

    let soundFilename: String = "carHorn.caf"

    let soundRate: Float = 2.5

    init(quantity: Int = 2) {
        self.quantity = quantity
    }

}
