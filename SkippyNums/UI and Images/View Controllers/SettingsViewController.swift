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

class SettingsViewController: SkippyNumsViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: - @IBOutlets

    @IBOutlet weak var maxGroupsPicker: UIPickerView?

    @IBOutlet weak var maxTriesPicker: UIPickerView?

    // MARK: - Properties - Objects

    // Stores settings for the game.
    var settingsData = SettingsData()

    var gameBrain = GameBrain.shared

    // MARK: - Properties - Arrays

    // The options in the "maximum number of groups" picker.
    var maxGroupsOptions = [5, 10]

    // The options in the "maximum number of tries per question" picker.
    var maxTriesOptions = [1, 2, 3, 5, 10]

    // MARK: - View Setup/Update

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // 1. Hide the system-provided back button--a more visually-accessible back button is used instead.
        navigationItem.hidesBackButton = true
        // 2. Configure the "maximum number of groups" picker.
        configureMaxGroupsPicker()
        // 3. Configure the "maximum number of tries per question" picker.
        configureMaxTriesPicker()
    }

    // MARK: - @IBActions - Back

    @IBAction func back(_ sender: SAIAccessibleButton) {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - @IBActions - Reset

    @IBAction func reset(_ sender: SAIAccessibleButton) {
        // 1. Reset all settings to default
        settingsData.tenFrame = false
        settingsData.maxTriesPerQuestion = 3
        // 2. Reconfigure the pickers.
        configureMaxGroupsPicker()
        configureMaxTriesPicker()
        // 3. Play a "correct answer" sound as confirmation.
        gameBrain.playAnswerSound(correct: true)
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
        // 3. Select the row corresponding to the current setting. If the current setting is false, the row is 0. If the current setting is true, the row is 1.
        let currentSetting = settingsData.tenFrame ? 1 : 0
        maxGroupsPicker?.selectRow(currentSetting, inComponent: 0, animated: true)
    }

    // MARK: - Max Tries Picker Configuration

    // This method configures the "maximum number of tries per question" picker.
    func configureMaxTriesPicker() {
        // 1. Configure accessibility of the max tries picker.
        maxTriesPicker?.isAccessibilityElement = true
        maxTriesPicker?.accessibilityLabel = "Maximum number of tries per question"
        // 2. Set the delegate and data source.
        maxTriesPicker?.delegate = self
        maxTriesPicker?.dataSource = self
        // 3. Select the row corresponding to the current setting. The row is the index of the item corresponding to the current setting, so we get the index of the current setting, not the current setting itself. If the setting isn't stored, select 3 tries (index 2).
        let currentSetting = settingsData.maxTriesPerQuestion
        let currentSettingRow = maxTriesOptions.firstIndex(of: currentSetting) ?? 2
        maxTriesPicker?.selectRow(currentSettingRow, inComponent: 0, animated: true)
    }

    // MARK: - Picker Delegate and Data Source - Info

    // A delegate tells an object what to do/how to display its content. In this case, the delegate handles picker row selection and provides the content to display for each row. A data source tells the object what to display. In this case, the data source determines the number of wheels and the number of rows for each wheel. At first glance, pickerView(_:viewForRow:forComponent:reusing:) looks like a data source method, since it doesn't have an action, "should", "will", or "did" in its name and we're filling rows with data, but it determines how to display the wheels and rows, not how many of them to display.
    // In this code, each picker view has a unique tag. This is used to determine which picker view to configure/how to configure it.
    // pickerView(_:viewForRow:forComponent:reusing:) is used here instead of pickerView(_:titleForRow:forComponent:) or pickerView(_:attributedTitleForRow:forComponent:) since we need to be able to customize more than just the title.
    /*
     The structure of a picker view is very simple!
     1. Create an array that will contain the picker data.
     2. Have numberOfComponents(in:) return the number of wheels for the picker.
     3. Have numberOfRowsInComponent(_:) return the array's item count.
     4. In pickerView(_:viewForRow:forComponent:reusing:), check the tag of the picker and fill that picker with data from the array. Tag checks are unnecessary when there's only one picker, as was the case until version 2026.3. For a picker with multiple wheels (components), check the component.
     5. In the same method, before selecting the picker, create a row view.
     6. Still in the same method, use the picker row to access the corresponding element in the array, and set the row view's data to that element or to data containing that element.
     7. pickerView(_:didSelectRow:inComponent:) is where you handle the selection of picker rows.
     */

    // MARK: - Picker Delegate and Data Source - Number of Components

    // Returns the number of components (wheels) for the picker.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        // All pickers here only have 1 wheel.
        let numberOfWheels = 1
        return numberOfWheels
    }

    // MARK: - Picker Delegate and Data Source - Number of Rows

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

    // MARK: - Picker Delegate and Data Source - Row Selection

    // Handles selection of picker rows on the given wheel.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // 1. Get the picker's tag.
        let pickerTag = pickerView.tag
        // 2. Change the respective setting.
        switch pickerTag {
        case 1:
            // Max tries picker
            let newTriesSetting = maxTriesOptions[row]
            settingsData.maxTriesPerQuestion = newTriesSetting
        default:
            // Max groups picker
            let newTenFrameSetting = row == 1
            settingsData.tenFrame = newTenFrameSetting
        }
    }

    // MARK: - Picker Delegate and Data Source - Row Content

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
        // 3. Set the title for the label based on the picker and row being configured.
        let pickerTag = pickerView.tag
        let optionTitle: String
        switch pickerTag {
        case 1:
            // Max tries picker
            let option = maxTriesOptions[row]
            optionTitle = String(option)
        default:
            // Max groups picker
            let option = maxGroupsOptions[row]
            optionTitle = String(option)
        }
        pickerLabel?.text = optionTitle
        // 4. Return the label as the picker item's view.
        return pickerLabel!
    }

    // MARK: - Picker Delegate and Data Source - Row Height

    // Returns the row height for the picker.
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        // All pickers here have a row height of 40px.
        return 40
    }

}
