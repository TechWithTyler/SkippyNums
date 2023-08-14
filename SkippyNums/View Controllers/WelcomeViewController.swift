//
//  WelcomeViewController.swift
//  SkippyNums
//
//  Created by TechWithTyler on 8/3/23.
//

import UIKit

class WelcomeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

	@IBOutlet weak var rowsPicker: UIPickerView!

	var gameBrain = GameBrain.shared

	var rowsOptions = ["5", "10"]

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
		configureRowsPicker()
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

	@IBAction func playSelected(_ sender: Any) {
		gameBrain.gameType = .play
		performSegue(withIdentifier: "ChooseGame", sender: sender)
	}

	@IBAction func practiceSelected(_ sender: Any) {
		gameBrain.gameType = .practice
		performSegue(withIdentifier: "ChooseGame", sender: sender)
	}

	@IBAction func learnSelected(_ sender: Any) {
		gameBrain.gameType = .learn
		performSegue(withIdentifier: "ChooseGame", sender: sender)
	}

	// MARK: - Navigation

	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// Get the new view controller using segue.destination.
		// Pass the selected object to the new view controller.
	}

}

extension WelcomeViewController {

	// MARK: - Rows Picker

	func configureRowsPicker() {
		rowsPicker.isAccessibilityElement = true
		rowsPicker.accessibilityLabel = "Maximum number of groups"
		rowsPicker.delegate = self
		rowsPicker.dataSource = self
		rowsPicker.selectRow(settingsData.tenFrame ? 1 : 0, inComponent: 0, animated: true)
	}

	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return 2
	}

	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		settingsData.tenFrame = row == 1 ? true : false
	}

	func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
		var pickerLabel: UILabel? = (view as? UILabel)
		if pickerLabel == nil {
			pickerLabel = UILabel()
			pickerLabel?.font = UIFont(name: "Helvetica", size: 30)
			pickerLabel?.textAlignment = .center
		}
		pickerLabel?.text = rowsOptions[row]
		return pickerLabel!
	}

}
