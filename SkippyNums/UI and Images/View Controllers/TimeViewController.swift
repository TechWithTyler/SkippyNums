//
//  TimeViewController.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 5/1/23.
//  Copyright © 2023-2026 SheftApps. All rights reserved.
//

// MARK: - Imports

import UIKit
import SheftAppsStylishUI

class TimeViewController: UIViewController {

    // MARK: - @IBOutlets

	@IBOutlet weak var untimedGameButton: SAIAccessibleButton?

    // MARK: - Properties - Objects

	var gameBrain = GameBrain.shared

    // MARK: - Properties - System Theme

    var systemTheme: UIUserInterfaceStyle {
        return traitCollection.userInterfaceStyle
    }

    // MARK: - View Setup/Update

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
        // 1. Hide the system-provided back button--a more visually-accessible back button is used instead.
        navigationItem.hidesBackButton = true
        // 2. Set up the gradient layer.
        setupGradient()
        // 3. Update the gradient colors when the device's dark/light mode changes.
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { [self] (self: Self, previousTraitCollection: UITraitCollection) in
            updateBackgroundColors()
        }
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if gameBrain.isNewRoundInCurrentGame {
            untimedGameButton?.isHidden = true
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

    // MARK: - @IBActions - Game Time Selection

	@IBAction func oneMinuteGame(_ sender: Any) {
		performSegue(withIdentifier: "TimedGame1", sender: sender)
	}

	@IBAction func twoMinuteGame(_ sender: Any) {
		performSegue(withIdentifier: "TimedGame2", sender: sender)
	}

	@IBAction func untimedGame(_ sender: Any) {
		performSegue(withIdentifier: "UntimedGame", sender: sender)
	}

    // MARK: - Navigation - Back @IBAction

	@IBAction func back(_ sender: SAIAccessibleButton) {
		navigationController?.popViewController(animated: true)
	}

	// MARK: - Navigation - Storyboard Segue Preparation

	// In a storyboard-based application, you will often want to do a little preparation before navigation.
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// Get the new view controller using segue.destination.
		// Pass the selected object to the new view controller.
        if let segueIdentifier = segue.identifier {
            // Set gameBrain.gameLength to the segue identifier's trailing number times 60, or nil if selecting "Untimed". For example, the segue identifier for the 2 minutes option is "TimedGame2"--multiply 2 by 60 to get 120 seconds or 2 minutes.
            if segueIdentifier.hasPrefix("Untimed") {
                gameBrain.gameLength = nil
            } else {
                let segueIdentifierTrailingNumber = segueIdentifier.filter { $0.isNumber }
                let gameLengthFromSegueIdentifier = TimeInterval(segueIdentifierTrailingNumber)! * 60
                gameBrain.gameLength = gameLengthFromSegueIdentifier
                // Uncomment the following line to override the time selection from the previous line when a shorter game length is desired for testing changes to the gameTimer ending. Comment out again after testing.
                // gameBrain.gameLength = 3
            }
        }
	}

}
