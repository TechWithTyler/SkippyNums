//
//  Bird.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 12/11/23.
//  Copyright © 2023 SheftApps. All rights reserved.
//

import Foundation

struct Bird: Object {

    var name: String {
        return "\(quantity)birds"
    }

    var quantity: Int

    var attributionText: String? = nil

    var soundFilename: String = "bird.caf"

    var soundRate: Float = 1

}
