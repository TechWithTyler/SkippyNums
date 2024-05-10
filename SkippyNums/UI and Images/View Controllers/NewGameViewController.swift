//
//  NewGameViewController.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 4/4/23.
//  Copyright © 2023-2024 SheftApps. All rights reserved.
//

import UIKit
import SheftAppsStylishUI

class NewGameViewController: UIViewController {

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

    // MARK: - @IBActions - Quantity Selection

    // For these @IBActions, the segue to use depends on the game type (play/practice/learn) selected on the main menu.

	@IBAction func twosSelected(_ sender: Any) {
		if gameBrain.gameType == .play {
			performSegue(withIdentifier: "NewGame2", sender: sender)
		} else if gameBrain.gameType == .learn {
			performSegue(withIdentifier: "Learn2", sender: sender)
		} else {
			performSegue(withIdentifier: "Practice2", sender: sender)
		}
	}

	@IBAction func fivesSelected(_ sender: Any) {
		if gameBrain.gameType == .play {
			performSegue(withIdentifier: "NewGame5", sender: sender)
		} else if gameBrain.gameType == .learn {
			performSegue(withIdentifier: "Learn5", sender: sender)
		} else {
			performSegue(withIdentifier: "Practice5", sender: sender)
		}
	}

	@IBAction func tensSelected(_ sender: Any) {
		if gameBrain.gameType == .play {
			performSegue(withIdentifier: "NewGame10", sender: sender)
		} else if gameBrain.gameType == .learn {
			performSegue(withIdentifier: "Learn10", sender: sender)
		} else {
			performSegue(withIdentifier: "Practice10", sender: sender)
		}
	}

	@IBAction func mixSelected(_ sender: Any) {
		if gameBrain.gameType == .play {
			performSegue(withIdentifier: "NewGameMix", sender: sender)
		} else if gameBrain.gameType == .learn {
			performSegue(withIdentifier: "LearnMix", sender: sender)
		} else {
			performSegue(withIdentifier: "PracticeMix", sender: sender)
		}
	}

    // MARK: - Navigation - Back @IBAction

	@IBAction func back(_ sender: SAIAccessibleButton) {
		gameBrain.countingBy = nil
		gameBrain.triesInGame = 0
		gameBrain.correctAnswersInGame = 0
		gameBrain.isNewRoundInCurrentGame = false
		navigationController?.popViewController(animated: true)
	}

    // MARK: - Navigation - Storyboard Segue Preparation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let segueIdentifier = segue.identifier {
            // Set gameBrain.countingBy to the segue identifier's trailing number, or nil if not provided (i.e., the suffix is "Mix" instead of a number).
            if segueIdentifier.hasSuffix("Mix") {
                gameBrain.countingBy = nil
            } else {
                let countingByFromSegueIdentifier = Int(String(segueIdentifier.filter( { $0.isNumber } )))
                gameBrain.countingBy = countingByFromSegueIdentifier
            }
        }
    }

}
