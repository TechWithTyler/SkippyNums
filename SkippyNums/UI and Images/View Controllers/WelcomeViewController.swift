//
//  WelcomeViewController.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 8/3/23.
//  Copyright © 2023-2026 SheftApps. All rights reserved.
//

// MARK: - Imports

import SheftAppsStylishUI

class WelcomeViewController: SkippyNumsViewController {

    // MARK: - Properties - Objects

    // Handles gameplay.
	var gameBrain = GameBrain.shared

    // MARK: - View Setup/Update

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}

    // MARK: - Game Selection - @IBActions

	@IBAction func playSelected(_ sender: Any) {
        chooseGame(type: .play, sender: sender)
	}

	@IBAction func practiceSelected(_ sender: Any) {
        chooseGame(type: .practice, sender: sender)
	}

	@IBAction func learnSelected(_ sender: Any) {
        chooseGame(type: .learn, sender: sender)
	}

    // MARK: - Game Selection - Selection Handler

    func chooseGame(type: GameBrain.GameType, sender: Any) {
        // 1. Set the game type to the selected game type.
        gameBrain.gameType = type
        // 2. Perform the segue with the selected game type.
        performSegue(withIdentifier: "ChooseGame", sender: sender)
    }

}
