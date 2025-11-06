//
//  Airplane.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 12/11/23.
//  Copyright © 2023-2025 SheftApps. All rights reserved.
//

// MARK: - Imports

import Foundation

struct Airplane: CountableObject {

    let name: String = "airplanes"

    let quantity: Int

    let soundFilename: String = "airplane.caf"

    let soundRate: Float = 5

    init(quantity: Int = 5) {
        self.quantity = quantity
    }

}
