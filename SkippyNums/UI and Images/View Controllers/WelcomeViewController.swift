//
//  WelcomeViewController.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 8/3/23.
//  Copyright © 2023-2026 SheftApps. All rights reserved.
//

// MARK: - Imports

import SheftAppsStylishUI

class WelcomeViewController: UIViewController {

    // MARK: - Properties - Objects

    // Handles gameplay.
	var gameBrain = GameBrain.shared

    // MARK: - Properties - System Theme

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

	func updateBackgroundColors() {
		// Update gradient colors based on device's dark/light mode
		if let gradientLayer = view.layer.sublayers?.first as? CAGradientLayer {
			gradientLayer.colors = systemTheme == .dark ? gradientColorsDark : gradientColorsLight
		}
	}

    func updateGradientFrame() {
        if let gradientLayer = view.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = view.bounds
        }
    }

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
        // Update frame of gradient layer when window size changes
		updateGradientFrame()
	}

    // MARK: - @IBActions

	@IBAction func playSelected(_ sender: Any) {
		gameBrain.gameType = .play
		performSegue(withIdentifier: "ChooseGame", sender: sender)
	}

	@IBAction func practiceSelected(_ sender: Any) {
		gameBrain.gameType = .practice
		performSegue(withIdentifier: "ChooseGame", sender: sender)
	}

	@IBAction func learnSelected(_ sender: Any) {
		gameBrain.gameType = .learn
		performSegue(withIdentifier: "ChooseGame", sender: sender)
	}

}
