//
//  AnswerCheckViewController.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 4/4/23.
//  Copyright © 2023-2024 SheftApps. All rights reserved.
//

import UIKit
import SheftAppsStylishUI

class AnswerCheckViewController: UIViewController {

	@IBOutlet weak var messageLabel: UILabel?

	@IBOutlet weak var checkXImageView: UIImageView?

	@IBOutlet weak var dismissButton: SAIAccessibleButton?

	var messageText: String?

	var baseImageName: String?

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		guard let messageText = messageText, let imageName = baseImageName else { return }
        messageLabel?.text = messageText
        checkXImageView?.image = UIImage(systemName: "\(imageName).circle.fill")
        checkXImageView?.tintColor = imageName == "x" ? .systemRed : .systemGreen
		if messageText.lowercased().components(separatedBy: [" ", "!"]).contains("correct") {
            dismissButton?.setTitle("Next Question", for: .normal)
		} else {
            dismissButton?.setTitle("Try Again", for: .normal)
		}
		// Create gradient layer
		let gradientLayer = CAGradientLayer()
		gradientLayer.frame = view.bounds
		gradientLayer.colors = traitCollection.userInterfaceStyle == .dark ? gradientColorsDark : gradientColorsLight
		gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
		gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
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

	@IBAction func dismiss(_ sender: Any) {
		dismiss(animated: true)
	}

}
