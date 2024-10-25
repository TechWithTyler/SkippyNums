//
//  TimeUpViewController.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 5/3/23.
//  Copyright © 2023-2024 SheftApps. All rights reserved.
//

import UIKit

class TimeUpViewController: UIViewController {

    // MARK: - @IBOutlets

	@IBOutlet weak var messageLabel: UILabel?

    // MARK: - Properties - Strings

	var messageText: String?

    // MARK: - Properties - Objects

	var gameBrain = GameBrain.shared

    // MARK: - Properties - System Theme

    var systemTheme: UIUserInterfaceStyle {
        return traitCollection.userInterfaceStyle
    }

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
        // 1. Set the message text.
		guard let messageText = messageText else { return }
        messageLabel?.text = messageText
        // 2. Hide the system-provided back button--a more visually-accessible back button is used instead.
        navigationItem.hidesBackButton = true
        // 3. Set up the gradient layer.
        setupGradient()
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

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        // Update the gradient colors when the device's dark/light mode changes
        updateBackgroundColors()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Update frame of gradient layer when window size changes
        updateGradientFrame()
    }

	@IBAction func nextRound(_ sender: Any) {
		// 1. Get the 2nd view controller (NewGameViewController, the view controller at index 1) in the stack.
        /* View controller stack:
         4: TimeUpViewController
         3: GameViewController
         2: TimeViewController
         1: NewGameViewController
         0: WelcomeViewController
         */
        guard let viewControllers = navigationController?.viewControllers, let newGameViewController = viewControllers[1] as? NewGameViewController else {
			return
		}
        // 2. Tell the GameBrain that a new round in the current game is starting, which will hide the Untimed option from the TimeViewController. The game resets if the player backs out from the NewGameViewController.
		gameBrain.isNewRoundInCurrentGame = true
        // 3. Go back to the NewGameViewController.
        navigationController?.popToViewController(newGameViewController, animated: true)
	}

	@IBAction func resetScore(_ sender: Any) {
        gameBrain.resetGame()
        navigationController?.popToRootViewController(animated: true)
	}

}
