//
//  Globals.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 12/11/23.
//  Copyright © 2023-2025 SheftApps. All rights reserved.
//

import UIKit

// MARK: - Properties - Edge Insets

// The edge insets of the sections of the object collection views in the GameViewController and LearnViewController.
var objectInsets: UIEdgeInsets {
    let verticalInsets: CGFloat = 50
    let horizontalInsets: CGFloat = 20
    let insets = UIEdgeInsets(
        top: verticalInsets,
        left: horizontalInsets,
        bottom: verticalInsets,
        right: horizontalInsets)
    return insets
}

// MARK: - Properties - Colors

// The colors to use for the gradient background in light theme.
let gradientColorsLight: [CGColor] = [(UIColor(named: "LightGradientBottom")?.cgColor)!, (UIColor(named: "LightGradientTop")?.cgColor)!, UIColor.white.cgColor]

// The colors to use for the gradient background in dark theme.
let gradientColorsDark: [CGColor] = [(UIColor(named: "DarkGradientBottom")?.cgColor)!, (UIColor(named: "DarkGradientTop")?.cgColor)!, UIColor.black.cgColor]
