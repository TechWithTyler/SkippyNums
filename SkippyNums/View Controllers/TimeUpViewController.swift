//
//  TimeUpViewController.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 5/3/23.
//

import UIKit

class TimeUpViewController: UIViewController {

	@IBOutlet weak var messageLabel: UILabel!

	var messageText: String?

	var gameBrain = GameBrain.shared

	private let gradientColorsLight: [CGColor] = [UIColor.systemRed.cgColor, UIColor.systemCyan.cgColor, UIColor.white.cgColor]

	private let gradientColorsDark: [CGColor] = [UIColor.systemPurple.cgColor, UIColor.black.cgColor]

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		guard let messageText = messageText else { return }
		messageLabel.text = messageText
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
		navigationController?.popToRootViewController(animated: true)
	}

	@IBAction func resetScore(_ sender: Any) {
		gameBrain.correctAnswersInGame = 0
		gameBrain.triesInGame = 0
		navigationController?.popToRootViewController(animated: true)
	}

}

