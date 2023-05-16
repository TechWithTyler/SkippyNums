//
//  NewGameViewController.swift
//  SkippyNums
//
//  Created by TechWithTyler on 4/4/23.
//

import UIKit

class NewGameViewController: UIViewController {

	private let gradientColorsLight: [CGColor] = [UIColor.systemRed.cgColor, UIColor.systemCyan.cgColor, UIColor.white.cgColor]

	private let gradientColorsDark: [CGColor] = [UIColor.systemPurple.cgColor, UIColor.black.cgColor]

	var gameBrain = GameBrain.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		// Create gradient layer
		let gradientLayer = CAGradientLayer()
		gradientLayer.frame = view.bounds
		gradientLayer.colors = traitCollection.userInterfaceStyle == .dark ? gradientColorsDark : gradientColorsLight
		gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
		gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
		// Add gradient layer to view
		view.layer.insertSublayer(gradientLayer, at: 0)
		setFonts()
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

	@IBAction func twosSelected(_ sender: Any) {
		performSegue(withIdentifier: "NewGame2", sender: sender)
	}

	@IBAction func fivesSelected(_ sender: Any) {
		performSegue(withIdentifier: "NewGame5", sender: sender)
	}

	@IBAction func tensSelected(_ sender: Any) {
		performSegue(withIdentifier: "NewGame10", sender: sender)
	}

	@IBAction func mixSelected(_ sender: Any) {
		performSegue(withIdentifier: "NewGameMix", sender: sender)
	}

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
		switch segue.identifier {
			case "NewGame2":
				gameBrain.countingBy = 2
			case "NewGame5":
				gameBrain.countingBy = 5
			case "NewGame10":
				gameBrain.countingBy = 10
			default:
				gameBrain.countingBy = nil
		}
    }

}
