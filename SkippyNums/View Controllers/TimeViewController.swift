//
//  TimeViewController.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 5/1/23.
//

import UIKit

class TimeViewController: UIViewController {

	@IBOutlet weak var untimedGameButton: UIButton!

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
		navigationItem.hidesBackButton = true
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if gameBrain.triesInGame > 0 {
			untimedGameButton.isHidden = true
		}
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

	@IBAction func oneMinuteGame(_ sender: Any) {
		performSegue(withIdentifier: "TimedGame1", sender: sender)
	}

	@IBAction func twoMinuteGame(_ sender: Any) {
		performSegue(withIdentifier: "TimedGame2", sender: sender)
	}

	@IBAction func untimedGame(_ sender: Any) {
		performSegue(withIdentifier: "UntimedGame", sender: sender)
	}

	@IBAction func back(_ sender: UIButton) {
		navigationController?.popViewController(animated: true)
	}


	// MARK: - Navigation

	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// Get the new view controller using segue.destination.
		// Pass the selected object to the new view controller.
		switch segue.identifier {
			case "TimedGame1":
				gameBrain.gameTimeLeft = 60
			case "TimedGame2":
				gameBrain.gameTimeLeft = 120
			default:
				gameBrain.gameTimeLeft = nil
		}
	}

}
