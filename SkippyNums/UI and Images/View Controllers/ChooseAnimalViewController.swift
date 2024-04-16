//
//  ChooseAnimalViewController.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 8/7/23.
//  Copyright © 2023-2024 SheftApps. All rights reserved.
//

import UIKit
import SheftAppsStylishUI

class ChooseAnimalViewController: UIViewController {

	var gameBrain = GameBrain.shared

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		navigationItem.hidesBackButton = true
		// Create gradient layer
		let gradientLayer = CAGradientLayer()
		gradientLayer.frame = view.bounds
		gradientLayer.colors = traitCollection.userInterfaceStyle == .dark ? gradientColorsDark : gradientColorsLight
		gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
		gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
		// Add gradient layer to view
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

	@IBAction func back(_ sender: SAIAccessibleButton) {
		navigationController?.popViewController(animated: true)
	}

	@IBAction func birdsSelected(_ sender: Any) {
        gameBrain.newLearnModeExample(withObject: Bird.self)
		performSegue(withIdentifier: "StartLearn", sender: sender)
	}

	@IBAction func monkeysSelected(_ sender: Any) {
		gameBrain.newLearnModeExample(withObject: Monkey.self)
		performSegue(withIdentifier: "StartLearn", sender: sender)
	}

    @IBAction func dogsSelected(_ sender: Any) {
        gameBrain.newLearnModeExample(withObject: Dog.self)
        performSegue(withIdentifier: "StartLearn", sender: sender)
    }

    @IBAction func catsSelected(_ sender: Any) {
        gameBrain.newLearnModeExample(withObject: Cat.self)
        performSegue(withIdentifier: "StartLearn", sender: sender)
    }

}
