//
//  WelcomeViewController.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 8/3/23.
//  Copyright © 2023-2024 SheftApps. All rights reserved.
//

import SheftAppsStylishUI

class WelcomeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: - @IBOutlets

	@IBOutlet weak var maxGroupsPicker: UIPickerView?

    // MARK: - Properties - Objects

    // Handles gameplay.
	var gameBrain = GameBrain.shared

    // Stores settings for the game.
    var settingsData = SettingsData()

    // MARK: - Properties - Arrays

    // The options in the "maximum number of groups" picker.
    var maxGroupsOptions = [5, 10]

    // MARK: - View Setup/Update

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		// Create gradient layer
		let gradientLayer = CAGradientLayer()
		gradientLayer.frame = view.bounds
		gradientLayer.colors = traitCollection.userInterfaceStyle == .dark ? gradientColorsDark : gradientColorsLight
		gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
		gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
		configureMaxGroupsPicker()
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

    // MARK: - @IBActions

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

}

extension WelcomeViewController {

	// MARK: - Max Groups Picker - Configuration

	func configureMaxGroupsPicker() {
        maxGroupsPicker?.isAccessibilityElement = true
		maxGroupsPicker?.accessibilityLabel = "Maximum number of groups"
		maxGroupsPicker?.delegate = self
		maxGroupsPicker?.dataSource = self
		maxGroupsPicker?.selectRow(settingsData.tenFrame ? 1 : 0, inComponent: 0, animated: true)
	}

    // MARK: - Max Groups Picker - Delegate and Data Source

    // Returns the number of components (wheels) for the picker.
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

    // Returns the number of rows for a given component (wheel) in the picker.
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return 2
	}

    // Handles selection of picker rows on the given wheel.
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		settingsData.tenFrame = row == 1 ? true : false
	}

    // Returns the content to display for the given row on the given wheel.
	func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        // 1. Create the label for the row.
		var pickerLabel: UILabel? = (view as? UILabel)
		if pickerLabel == nil {
			pickerLabel = UILabel()
			pickerLabel?.font = UIFont(name: "Helvetica", size: 40)
			pickerLabel?.textAlignment = .center
            pickerLabel?.layer.cornerRadius = 12
        }
        // 2. Get the title for the label based on the row being configured.
        let optionTitle = String(maxGroupsOptions[row])
        pickerLabel?.text = optionTitle
        // 3. Set the background color and text color of the row.
        pickerLabel?.textColor = .white
        pickerLabel?.layer.backgroundColor = UIColor.tintColor.cgColor
        // 4. Return the label as the picker item's view.
		return pickerLabel!
	}

    // Returns the row height for the picker.
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }

}
