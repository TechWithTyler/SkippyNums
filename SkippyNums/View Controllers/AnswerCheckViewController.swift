//
//  AnswerCheckViewController.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 4/4/23.
//

import UIKit

class AnswerCheckViewController: UIViewController {

	@IBOutlet weak var messageLabel: UILabel!

	@IBOutlet weak var checkXImageView: UIImageView!

	@IBOutlet weak var dismissButton: UIButton!

	var messageText: String?

	var imageName: String?

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		guard let messageText = messageText, let imageName = imageName else { return }
		messageLabel.text = messageText
		checkXImageView.image = UIImage(systemName: "\(imageName).circle.fill")
		checkXImageView.tintColor = imageName == "x" ? .systemRed : .systemGreen
		if messageText.lowercased().components(separatedBy: [" ", "!"]).contains("correct") {
			dismissButton.setTitle("Next Question", for: .normal)
		} else {
			dismissButton.setTitle("Try Again", for: .normal)
		}
		setFonts()
	}

	func setFonts() {
		for view in view.subviews {
			if let button = view as? UIButton {
				button.configuration?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
					var outgoing = incoming
					outgoing.font = UIFont.systemFont(ofSize: 40)
					return outgoing
				}
				button.layer.shadowColor = UIColor.black.cgColor
				button.layer.shadowOffset = CGSize(width: 2, height: 2)
				button.layer.shadowOpacity = 0.5
				button.layer.shadowRadius = 4
			}
		}
	}

	@IBAction func dismiss(_ sender: Any) {
		dismiss(animated: true)
	}

}
