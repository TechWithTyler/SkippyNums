//
//  AnswerCheckViewController.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 4/4/23.
//  Copyright © 2023-2026 SheftApps. All rights reserved.
//

// MARK: - Imports

import UIKit
import SheftAppsStylishUI

class AnswerCheckViewController: SkippyNumsViewController {

    // MARK: - @IBOutlets

	@IBOutlet weak var messageLabel: UILabel?

	@IBOutlet weak var checkXImageView: UIImageView?

	@IBOutlet weak var dismissButton: SAIAccessibleButton?

    // MARK: - Properties - Strings

    // The message text passed in from the GameViewController.
	var messageText: String?

    // The base image name passed in from the GameViewController. The base image name doesn't include the ".circle.fill" suffix as it's common to both images, so it's applied when setting the image here.
	var baseImageName: String?

    // MARK: - View Setup/Update

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		// 1. Set up the "correct or incorrect" display.
        setupAnswerCheckDisplay()
	}

    func setupAnswerCheckDisplay() {
        // 1. Set the message text and image.
        guard let messageText = messageText, let baseImageName = baseImageName else { return }
        messageLabel?.text = messageText
        checkXImageView?.image = UIImage(systemName: "\(baseImageName).circle.fill")
        // 2. Use green for the checkmark and red for the X.
        checkXImageView?.tintColor = baseImageName == "x" ? .systemRed : .systemGreen
        // 3. Set the button title based on whether the chosen answer is correct, incorrect, or incorrect too many times in a row.
        if messageText.lowercased().components(separatedBy: [" ", "!"]).contains("correct") {
            dismissButton?.setTitle("Next Question", for: .normal)
        } else {
            dismissButton?.setTitle("Try Again", for: .normal)
        }
    }

    // MARK: - @IBActions

	@IBAction func dismiss(_ sender: Any) {
		dismiss(animated: true)
	}

}
