//
//  Airplane.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 12/11/23.
//  Copyright © 2023-2025 SheftApps. All rights reserved.
//

import Foundation

struct Airplane: CountableObject {

    var name: String = "airplanes"

    var quantity: Int

    var soundFilename: String = "airplane.caf"

    var soundRate: Float = 5

    init(quantity: Int = 5) {
        self.quantity = quantity
    }

}
