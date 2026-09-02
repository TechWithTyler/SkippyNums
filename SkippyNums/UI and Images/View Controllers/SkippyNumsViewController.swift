//
//  SkippyNumsViewController.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 1/29/26.
//  Copyright © 2023-2026 SheftApps. All rights reserved.
//

import UIKit

// The common superclass for all view controllers in the game. Prior to version 2026.3, the gradient layer was created in each view controller individually.
class SkippyNumsViewController: UIViewController {

    // MARK: - Properties - System Theme

    // The current system theme.
    var systemTheme: UIUserInterfaceStyle {
        return traitCollection.userInterfaceStyle
    }

    // MARK: - View Setup/Update

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // 1. Set up the gradient layer.
        setupGradientBackground()
        // 2. Update the gradient colors when the system theme changes.
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { [self] (self: Self, previousTraitCollection: UITraitCollection) in
            updateBackgroundColors()
        }
    }
    
    // This method sets up the gradient background.
    func setupGradientBackground() {
        // 1. Create the gradient layer.
        let gradientLayer = CAGradientLayer()
        // UInt32 means an unsigned 32bit integer. Unsigned means it can't be negative. "32bit integer" means it can't store numbers larger than binary number 11111111111111111111111111111111 which is 32 digits long, where each digit is a bit. A signed integer can store negative numbers, but the largest positive number is lower as a result. In the case of a 32bit integer, an unsigned one like this can range from 0 to 4,294,967,295, while a signed one can range from -2,147,483,648 (binary number 10000000000000000000000000000000) to 2,147,483,647 (binary number 01111111111111111111111111111111). 0 is binary number 00000000000000000000000000000000, 1 is binary number 00000000000000000000000000000001, and -1 is binary number 11111111111111111111111111111111.
        let layerIndex: UInt32 = 0
        gradientLayer.frame = view.bounds
        gradientLayer.colors = systemTheme == .dark ? gradientColorsDark : gradientColorsLight
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
        // 2. Add the gradient layer to the view as its back-most layer. The UI is "pushed forward" and sits on top of this layer.
        view.layer.insertSublayer(gradientLayer, at: layerIndex)
    }

    // This method updates the gradient's background colors when the system theme changes.
    func updateBackgroundColors() {
        // Update the gradient colors based on system theme. The gradient layer is the view's first (back-most) sublayer, as it's added as layer 0 in the stack.
        if let gradientLayer = view.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.colors = systemTheme == .dark ? gradientColorsDark : gradientColorsLight
        }
    }

    // This method updates the gradient frame when the window size changes.
    func updateGradientFrame() {
        // Update the gradient frame based on window size. The gradient layer is the view's first (back-most) sublayer, as it's added as layer 0 in the stack.
        if let gradientLayer = view.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = view.bounds
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Update frame of gradient layer when the window size changes.
        updateGradientFrame()
    }

}
