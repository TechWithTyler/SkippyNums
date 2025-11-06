//
//  Bird.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 12/11/23.
//  Copyright © 2023-2025 SheftApps. All rights reserved.
//

// MARK: - Imports

import Foundation

struct Bird: CountableObject {

    var name: String {
        return "\(quantity)birds"
    }

    let quantity: Int

    let soundFilename: String = "bird.caf"

    let soundRate: Float = 1

    init(quantity: Int) {
        self.quantity = quantity
    }

}
