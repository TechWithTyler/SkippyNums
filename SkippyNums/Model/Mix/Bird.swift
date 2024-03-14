//
//  Bird.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 12/11/23.
//  Copyright © 2023-2024 SheftApps. All rights reserved.
//

import Foundation

struct Bird: CountableObject {

    var name: String {
        return "\(quantity)birds"
    }

    var quantity: Int

    var soundFilename: String = "bird.caf"

    var soundRate: Float = 1

}
