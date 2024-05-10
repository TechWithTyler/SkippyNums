//
//  TimeViewController.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 5/1/23.
//  Copyright © 2023-2024 SheftApps. All rights reserved.
//

import UIKit
import SheftAppsStylishUI

class TimeViewController: UIViewController {

    // MARK: - @IBOutlets

	@IBOutlet weak var untimedGameButton: SAIAccessibleButton?

    // MARK: - Properties - Objects

	var gameBrain = GameBrain.shared

    // MARK: - View Setup/Update

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
        // 1. Hide the system-provided back button--a more visually-accessible back button is used instead.
        navigationItem.hidesBackButton = true
        // 2. Set up the gradient layer.
        setupGradient()
	}

    func setupGradient() {
        // 1. Create the gradient layer.
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = traitCollection.userInterfaceStyle == .dark ? gradientColorsDark : gradientColorsLight
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
        // 2. Add the gradient layer to the view.
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if gameBrain.isNewRoundInCurrentGame {
            untimedGameButton?.isHidden = true
		}
	}

	@objc func updateBackgroundColors() {
		// Update gradient colors based on device's dark/light mode
		if let gradientLayer = view.layer.sublayers?.first as? CAGradientLayer {
			gradientLayer.colors = traitCollection.userInterfaceStyle == .dark ? gradientColorsDark : gradientColorsLight
		}
	}

	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		// Update gradient colors when device's dark/light mode changes
		updateBackgroundColors()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		if let gradientLayer = view.layer.sublayers?.first as? CAGradientLayer {
			gradientLayer.frame = view.bounds
		}
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

	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// Get the new view controller using segue.destination.
		// Pass the selected object to the new view controller.
        if let segueIdentifier = segue.identifier {
            // Set gameBrain.gameLength to the segue identifier's trailing number times 60, or nil if selecting "Untimed".
            if segueIdentifier.hasPrefix("Untimed") {
                gameBrain.gameLength = nil
            } else {
                let gameTimeLeftFromSegueIdentifier = (TimeInterval(String(segueIdentifier.filter( { $0.isNumber } ))))! * 60
                gameBrain.gameLength = gameTimeLeftFromSegueIdentifier
            }
        }
	}

}
