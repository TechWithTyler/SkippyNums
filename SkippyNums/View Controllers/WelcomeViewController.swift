//
//  WelcomeViewController.swift
//  SkippyNums
//
//  Created by TechWithTyler on 8/3/23.
//

import UIKit

class WelcomeViewController: UIViewController {

	@IBOutlet weak var fiveTenFrameToggleButton: UIButton!

	var gameBrain = GameBrain.shared

	var settingsData = SettingsData()

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
		configureFiveTenFrameButtonTitle()
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

	func configureFiveTenFrameButtonTitle() {
		let frameCount: Int = settingsData.tenFrame ? 5 : 10
		fiveTenFrameToggleButton.setTitle("Switch to \(frameCount)-Frame", for: .normal)
	}

	@IBAction func toggleFiveTenFrame(_ sender: UIButton) {
		settingsData.tenFrame.toggle()
		configureFiveTenFrameButtonTitle()
		setFonts()
	}

	@IBAction func playSelected(_ sender: Any) {
		performSegue(withIdentifier: "Play", sender: sender)
	}

	@IBAction func practiceSelected(_ sender: Any) {
		performSegue(withIdentifier: "Practice", sender: sender)
	}

	@IBAction func learnSelected(_ sender: Any) {
		performSegue(withIdentifier: "Learn", sender: sender)
	}

	// MARK: - Navigation

	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// Get the new view controller using segue.destination.
		// Pass the selected object to the new view controller.
		switch segue.identifier {
			case "Learn":
				gameBrain.gameType = .learn
			case "Practice":
				gameBrain.gameType = .practice
			default:
				gameBrain.gameType = .play
		}
	}

}
