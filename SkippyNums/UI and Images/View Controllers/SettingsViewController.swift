//
//  SettingsViewController.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 1/27/26.
//  Copyright © 2023-2026 SheftApps. All rights reserved.
//

// MARK: - Imports

import UIKit
import SheftAppsStylishUI

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: - @IBOutlets

    @IBOutlet weak var maxGroupsPicker: UIPickerView?

    @IBOutlet weak var maxTriesPicker: UIPickerView?

    // MARK: - Properties - Objects

    var settingsData = SettingsData()

    // MARK: - Properties - Arrays

    // The options in the "maximum number of groups" picker.
    var maxGroupsOptions = [5, 10]

    // The options in the "maximum number of inccorrect answers per question" picker.
    var maxTriesOptions = [3, 5, 10]

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
        // 4. Configure the "maximum number of groups" picker.
        configureMaxGroupsPicker()
        // 5. Configure the "maximum number of incorrect answers per question" picker.
        configureMaxTriesPicker()
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

    // MARK: - @IBActions - Back

    @IBAction func back(_ sender: SAIAccessibleButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension SettingsViewController {

    // MARK: - Max Groups Picker Configuration

    // This method configures the "maximum number of groups" picker.
    func configureMaxGroupsPicker() {
        // 1. Configure accessibility of the max groups picker.
        maxGroupsPicker?.isAccessibilityElement = true
        maxGroupsPicker?.accessibilityLabel = "Maximum number of groups"
        // 2. Set the delegate and data source. The delegate is notified when things happen with an object (in this case, a UIPickerView), and the data source tells it what data it should contain. An object's delegate and data source are always used together and are often set to the same object, in this case, WelcomeViewController.
        maxGroupsPicker?.delegate = self
        maxGroupsPicker?.dataSource = self
        // 3. Select the row corresponding to the current setting.
        let currentSetting = settingsData.tenFrame ? 1 : 0
        maxGroupsPicker?.selectRow(currentSetting, inComponent: 0, animated: true)
    }

    // MARK: - Max Tries Configuration

    // This method configures the "maximum number of tries per question" picker.
    func configureMaxTriesPicker() {
        // 1. Configure accessibility of the max tries picker.
        maxTriesPicker?.isAccessibilityElement = true
        maxTriesPicker?.accessibilityLabel = "Maximum number of tries per question"
        // 2. Set the delegate and data source.
        maxTriesPicker?.delegate = self
        maxTriesPicker?.dataSource = self
        // 3. Select the row corresponding to the current setting.
        let currentSetting = settingsData.maxTriesPerQuestion
        let currentSettingRow = maxTriesOptions.firstIndex(of: currentSetting) ?? 0
        maxTriesPicker?.selectRow(currentSettingRow, inComponent: 0, animated: true)
    }

    // MARK: - Picker Delegate and Data Source

    // Returns the number of components (wheels) for the picker.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        let numberOfWheels = 1
        return numberOfWheels
    }

    // Returns the number of rows for a given component (wheel) in the picker.
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // 1. Get the picker's tag, which is used to determine which picker to configure.
        let pickerTag = pickerView.tag
        // 2. Set the number of options based on the picker's tag.
        let numberOfOptions: Int
        switch pickerTag {
        case 1: numberOfOptions = maxTriesOptions.count
        default: numberOfOptions = maxGroupsOptions.count
        }
        // 3. Return the number of options.
        return numberOfOptions
    }

    // Handles selection of picker rows on the given wheel.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // 1. Get the picker's tag.
        let pickerTag = pickerView.tag
        // 2. Change the respective setting.
        switch pickerTag {
        case 1:
            let newTriesSetting = maxTriesOptions[row]
            settingsData.maxTriesPerQuestion = newTriesSetting
        default:
        let newTenFrameSetting = row == 1
        settingsData.tenFrame = newTenFrameSetting
        }
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
        // 2. Set the background color and text color of the row.
        pickerLabel?.textColor = .white
        pickerLabel?.layer.backgroundColor = UIColor.tintColor.cgColor
        // 3. Get the title for the label based on the picker and row being configured.
        let pickerTag = pickerView.tag
        let optionTitle: String
        switch pickerTag {
        case 1:
            let option = maxTriesOptions[row]
            optionTitle = String(option)
        default:
            let option = maxGroupsOptions[row]
            optionTitle = String(option)
        }
        pickerLabel?.text = optionTitle
        // 4. Return the label as the picker item's view.
        return pickerLabel!
    }

    // Returns the row height for the picker.
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }

}
