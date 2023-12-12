//
//  Monkey.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 12/11/23.
//  Copyright © 2023 SheftApps. All rights reserved.
//

import Foundation

struct Monkey: Object {

    var name: String {
        return "\(quantity)monkeys"
    }

    var quantity: Int

    var attributionText: String? = nil

    var soundFilename: String = "monkey.caf"

    var soundRate: Float = 1.5

}