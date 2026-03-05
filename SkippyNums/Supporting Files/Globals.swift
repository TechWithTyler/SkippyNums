//
//  Globals.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 12/11/23.
//  Copyright © 2023-2026 SheftApps. All rights reserved.
//

// MARK: - Imports

import SheftAppsStylishUI

// MARK: - Properties - Edge Insets

// The edge insets of the sections of the object collection views in the GameViewController and LearnViewController.
var objectInsets: UIEdgeInsets {
    // 1. Define the edge inset amounts.
    let verticalInsetAmount: CGFloat = 50
    let horizontalInsetAmount: CGFloat = 20
    // 2. Create a UIEdgeInsets object, using the vertical inset amount for the top and bottom edges and the horizontal inset amount for the left and right edges. This adds 50px of padding to the top and bottom of the view and 20px of padding to the left and right of the view.
    let insets = UIEdgeInsets(
        // 50px
        top: verticalInsetAmount,
        // 20px
        left: horizontalInsetAmount,
        // 50px
        bottom: verticalInsetAmount,
        // 20px
        right: horizontalInsetAmount)
    // 3. Return the inset object.
    return insets
}

// MARK: - Properties - Colors

// The colors to use for the gradient background in light theme.
let gradientColorsLight: [CGColor] = [
    UIColor.lightGradientBottom.cgColor,
    UIColor.lightGradientTop.cgColor,
    UIColor.white.cgColor
]

// The colors to use for the gradient background in dark theme.
let gradientColorsDark: [CGColor] = [
    UIColor.darkGradientBottom.cgColor,
    UIColor.darkGradientTop.cgColor,
    UIColor.black.cgColor
]
