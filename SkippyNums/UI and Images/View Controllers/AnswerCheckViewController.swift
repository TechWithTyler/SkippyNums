//
//  AnswerCheckViewController.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 4/4/23.
//  Copyright © 2023-2025 SheftApps. All rights reserved.
//

import UIKit
import SheftAppsStylishUI

class AnswerCheckViewController: UIViewController {

    // MARK: - @IBOutlets

	@IBOutlet weak var messageLabel: UILabel?

	@IBOutlet weak var checkXImageView: UIImageView?

	@IBOutlet weak var dismissButton: SAIAccessibleButton?

    // MARK: - Properties - Strings

    // The message text passed in from the GameViewController.
	var messageText: String?

    // The base image name passed in from the GameViewController. The base image name doesn't include the ".circle.fill" suffix as it's common to both images, so it's applied when setting the image here.
	var baseImageName: String?

    // MARK: - Properties - System Theme

    var systemTheme: UIUserInterfaceStyle {
        return traitCollection.userInterfaceStyle
    }

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		// 1. Set up the "correct or incorrect" display.
        setupAnswerCheckDisplay()
		// 2. Set up the gradient layer.
        setupGradient()
	}

    func setupAnswerCheckDisplay() {
        // 1. Set the message text and image.
        guard let messageText = messageText, let baseImageName = baseImageName else { return }
        messageLabel?.text = messageText
        checkXImageView?.image = UIImage(systemName: "\(baseImageName).circle.fill")
        // 2. Use green for the checkmark and red for the X.
        checkXImageView?.tintColor = baseImageName == "x" ? .systemRed : .systemGreen
        // 3. Set the button title based on whether the chosen answer is correct, incorrect, or the 3rd incorrect one in a row.
        if messageText.lowercased().components(separatedBy: [" ", "!"]).contains("correct") {
            dismissButton?.setTitle("Next Question", for: .normal)
        } else {
            dismissButton?.setTitle("Try Again", for: .normal)
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

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        // Update the gradient colors when the device's dark/light mode changes
        updateBackgroundColors()
    }

	@IBAction func dismiss(_ sender: Any) {
		dismiss(animated: true)
	}

}
