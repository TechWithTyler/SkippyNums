//
//  TimeUpViewController.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 5/3/23.
//  Copyright © 2023-2024 SheftApps. All rights reserved.
//

import UIKit

class TimeUpViewController: UIViewController {

	@IBOutlet weak var messageLabel: UILabel?

	var messageText: String?

	var gameBrain = GameBrain.shared

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		guard let messageText = messageText else { return }
        messageLabel?.text = messageText
		// Create gradient layer
		let gradientLayer = CAGradientLayer()
		gradientLayer.frame = view.bounds
		gradientLayer.colors = traitCollection.userInterfaceStyle == .dark ? gradientColorsDark : gradientColorsLight
		gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
		gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
		// Add gradient layer to view
		view.layer.insertSublayer(gradientLayer, at: 0)
		setFonts()
		navigationItem.hidesBackButton = true
	}

	func setFonts() {
		for view in view.subviews {
			if let button = view as? UIButton {
				button.configuration?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
					var outgoing = incoming
					outgoing.font = UIFont.systemFont(ofSize: 40)
					return outgoing
				}
				button.layer.shadowColor = UIColor.black.cgColor
				button.layer.shadowOffset = CGSize(width: 2, height: 2)
				button.layer.shadowOpacity = 0.5
				button.layer.shadowRadius = 4
			}
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

	@IBAction func nextRound(_ sender: Any) {
		// Make sure there are at least 3 view controllers in the stack. If there are, get the third-to-last view controller. Since the index starts at 0, we need to subtract 4, not 3, from the view controller count.
		let viewControllers = navigationController?.viewControllers
		guard let viewControllerCount = viewControllers?.count, viewControllerCount >= 3, let newGameViewController = viewControllers?[viewControllerCount - 4] as? NewGameViewController else {
			return
		}
		gameBrain.isNewRoundInCurrentGame = true
        navigationController?.popToViewController(newGameViewController, animated: true)
	}

	@IBAction func resetScore(_ sender: Any) {
		gameBrain.correctAnswersInGame = 0
		gameBrain.triesInGame = 0
		gameBrain.isNewRoundInCurrentGame = false
        navigationController?.popToRootViewController(animated: true)
	}

}
