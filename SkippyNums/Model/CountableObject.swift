//
//  CountableObject.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 2/13/23.
//  Copyright © 2023-2024 SheftApps. All rights reserved.
//

import Foundation

// MARK - CountableObject Protocol

// An object to count.
protocol CountableObject {

    // The name of the object.
	var name: String { get }

    // The number of times this object appears in an image.
	var quantity: Int { get }

    // The attribution text for the image, if any.
	var attributionText: String? { get }

    // The filename of the sound that plays when the image is tapped/clicked.
	var soundFilename: String { get }

    // The rate of the sound that plays when the image is tapped/clicked.
	var soundRate: Float { get }

}
