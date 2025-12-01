//
//  Globals.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 12/11/23.
//  Copyright © 2023-2026 SheftApps. All rights reserved.
//

// MARK: - Imports

import UIKit

// MARK: - Properties - Edge Insets

// The edge insets of the sections of the object collection views in the GameViewController and LearnViewController.
var objectInsets: UIEdgeInsets {
    let verticalInsetAmount: CGFloat = 50
    let horizontalInsetAmount: CGFloat = 20
    let insets = UIEdgeInsets(
        top: verticalInsetAmount,
        left: horizontalInsetAmount,
        bottom: verticalInsetAmount,
        right: horizontalInsetAmount)
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
