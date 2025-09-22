//
//  NewGameViewController.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 4/4/23.
//  Copyright © 2023-2025 SheftApps. All rights reserved.
//

import UIKit
import SheftAppsStylishUI

class NewGameViewController: UIViewController {

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

    // MARK: - Quantity Selection - @IBActions

    // For these @IBActions, the segue to use depends on the game type (play/practice/learn) selected on the main menu.

	@IBAction func twosSelected(_ sender: Any) {
        handleGameSelection(number: 2, sender: sender)
	}

	@IBAction func fivesSelected(_ sender: Any) {
        handleGameSelection(number: 5, sender: sender)
	}

	@IBAction func tensSelected(_ sender: Any) {
        handleGameSelection(number: 10, sender: sender)
	}

	@IBAction func mixSelected(_ sender: Any) {
        handleGameSelection(number: nil, sender: sender)
	}

    // MARK: - Quantity Selection - Selection Handler

    func handleGameSelection(number: Int?, sender: Any) {
        // 1. Create the quantity part of the segue identifier based on number.
        var quantity: String {
            if let number = number {
                return String(number)
            } else {
                return "Mix"
            }
        }
        // 2. Choose the segue to use based on the game type and the value of quantity.
        switch gameBrain.gameType {
        case .practice:
            performSegue(withIdentifier: "Practice\(quantity)", sender: sender)
        case .learn:
            performSegue(withIdentifier: "Learn\(quantity)", sender: sender)
        default:
            performSegue(withIdentifier: "NewGame\(quantity)", sender: sender)
        }
    }

    // MARK: - Navigation - Back @IBAction

	@IBAction func back(_ sender: SAIAccessibleButton) {
        // 1. Reset the game.
		gameBrain.resetGame()
        // 2. Go back to the previous screen.
		navigationController?.popViewController(animated: true)
	}

    // MARK: - Navigation - Storyboard Segue Preparation

    // In a storyboard-based application, you will often want to do a little preparation before navigation.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let segueIdentifier = segue.identifier {
            // Set gameBrain.countingBy to the segue identifier's trailing number, or nil if not provided (i.e., the suffix is "Mix" instead of a number).
            if segueIdentifier.hasSuffix("Mix") {
                gameBrain.countingBy = nil
            } else {
                let segueIdentifierTrailingNumber = segueIdentifier.filter { $0.isNumber }
                let countingByFromSegueIdentifier = Int(segueIdentifierTrailingNumber)
                gameBrain.countingBy = countingByFromSegueIdentifier
            }
        }
    }

}
