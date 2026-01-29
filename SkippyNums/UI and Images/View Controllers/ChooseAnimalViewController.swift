//
//  ChooseAnimalViewController.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 8/7/23.
//  Copyright © 2023-2026 SheftApps. All rights reserved.
//

// MARK: - Imports

import UIKit
import SheftAppsStylishUI

class ChooseAnimalViewController: SkippyNumsViewController {

    // MARK: - Properties - Objects

	var gameBrain = GameBrain.shared

    // MARK: - View Setup/Update

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
        // Hide the system-provided back button--a more visually-accessible back button is used instead.
        navigationItem.hidesBackButton = true
	}

    // MARK: - @IBActions - Back

	@IBAction func back(_ sender: SAIAccessibleButton) {
		navigationController?.popViewController(animated: true)
	}

    // MARK: - @IBActions - Animal Selection

    @IBAction func dogsSelected(_ sender: Any) {
        gameBrain.startLearnMode(withObject: Dog.self)
        performSegue(withIdentifier: "StartLearn", sender: sender)
    }

    @IBAction func catsSelected(_ sender: Any) {
        gameBrain.startLearnMode(withObject: Cat.self)
        performSegue(withIdentifier: "StartLearn", sender: sender)
    }

	@IBAction func monkeysSelected(_ sender: Any) {
		gameBrain.startLearnMode(withObject: Monkey.self)
		performSegue(withIdentifier: "StartLearn", sender: sender)
	}

    @IBAction func birdsSelected(_ sender: Any) {
        gameBrain.startLearnMode(withObject: Bird.self)
        performSegue(withIdentifier: "StartLearn", sender: sender)
    }

}
