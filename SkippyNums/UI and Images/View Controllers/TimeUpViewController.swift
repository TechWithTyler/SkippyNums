//
//  TimeUpViewController.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 5/3/23.
//  Copyright © 2023-2026 SheftApps. All rights reserved.
//

// MARK: - Imports

import UIKit

class TimeUpViewController: SkippyNumsViewController {

    // MARK: - @IBOutlets

	@IBOutlet weak var messageLabel: UILabel?

    @IBOutlet weak var timeUpImageView: UIImageView?
    
    // MARK: - Properties - Strings

	var messageText: String?

    // MARK: - Properties - Objects

	var gameBrain = GameBrain.shared

    // MARK: - View Setup/Update

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
        // 1. Set the message text.
		guard let messageText = messageText else { return }
        messageLabel?.text = messageText
        // 2. Hide the system-provided back button--a back button isn't needed here.
        navigationItem.hidesBackButton = true
        // 3. Add an animation to the image.
        if #available(iOS 18, *) {
            timeUpImageView?.addSymbolEffect(.wiggle, options: .repeat(.periodic(3, delay: 0)).speed(2))
        }
    }

    // MARK: - @IBActions

	@IBAction func nextRound(_ sender: Any) {
		// 1. Get the 2nd view controller (NewGameViewController, the view controller at index 1) in the stack.
        /* View controller stack when TimeUpViewController is presented:
         Index 4 (top of stack): TimeUpViewController
         Index 3: GameViewController
         Index 2: TimeViewController
         Index 1: NewGameViewController
         Index 0 (bottom/root of stack): WelcomeViewController
         */
        let newGameViewControllerIndex = 1
        guard let viewControllers = navigationController?.viewControllers, let newGameViewController = viewControllers[newGameViewControllerIndex] as? NewGameViewController else {
			return
		}
        // 2. Tell the GameBrain that a new round in the current game is starting, which will hide the Untimed option from the TimeViewController. The game resets if the player backs out from the NewGameViewController.
		gameBrain.isNewRoundInCurrentGame = true
        // 3. Go back to the NewGameViewController.
        gameBrain.soundPlayer?.stop()
        navigationController?.popToViewController(newGameViewController, animated: true)
	}

	@IBAction func resetScore(_ sender: Any) {
        gameBrain.resetGame()
        navigationController?.popToRootViewController(animated: true)
	}

}
