//
//  WelcomeViewController.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 8/3/23.
//  Copyright © 2023-2025 SheftApps. All rights reserved.
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

    // MARK: - Properties - System Theme

    var systemTheme: UIUserInterfaceStyle {
        return traitCollection.userInterfaceStyle
    }

    // MARK: - View Setup/Update

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		// 1. Set up the gradient layer.
        setupGradient()
        // 2. Configure the "maximum number of groups" picker.
        configureMaxGroupsPicker()
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
        // 1. Configure accessibility of the max groups picker.
        maxGroupsPicker?.isAccessibilityElement = true
		maxGroupsPicker?.accessibilityLabel = "Maximum number of groups"
        // 2. Set the delegate and data source.
		maxGroupsPicker?.delegate = self
		maxGroupsPicker?.dataSource = self
        // Select the row corresponding to the current setting.
		maxGroupsPicker?.selectRow(settingsData.tenFrame ? 1 : 0, inComponent: 0, animated: true)
	}

    // MARK: - Max Groups Picker - Delegate and Data Source

    // Returns the number of components (wheels) for the picker.
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
        let numberOfWheels = 1
        return numberOfWheels
	}

    // Returns the number of rows for a given component (wheel) in the picker.
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let numberOfOptions = 2
        return numberOfOptions
	}

    // Handles selection of picker rows on the given wheel.
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		settingsData.tenFrame = row == 1 
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
