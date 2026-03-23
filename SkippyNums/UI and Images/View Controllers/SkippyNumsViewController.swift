//
//  SkippyNumsViewController.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 1/29/26.
//  Copyright © 2023-2026 SheftApps. All rights reserved.
//

import UIKit

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
        setupGradient()
        // 2. Update the gradient colors when the device's dark/light mode changes.
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { [self] (self: Self, previousTraitCollection: UITraitCollection) in
            updateBackgroundColors()
        }
    }
    
    // This method sets up the gradient background.
    func setupGradient() {
        // 1. Create the gradient layer.
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = systemTheme == .dark ? gradientColorsDark : gradientColorsLight
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
        // 2. Add the gradient layer to the view.
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    // This method updates the gradient's background colors when the system theme changes.
    func updateBackgroundColors() {
        // Update gradient colors based on system theme
        if let gradientLayer = view.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.colors = systemTheme == .dark ? gradientColorsDark : gradientColorsLight
        }
    }

    // This method updates the gradient frame based on window size.
    func updateGradientFrame() {
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
