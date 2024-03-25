//
//  GameViewController.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 2/13/23.
//  Copyright © 2023-2024 SheftApps. All rights reserved.
//

import UIKit
import AVFoundation
import SheftAppsStylishUI

class GameViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {

    // MARK: - @IBOutlets - Buttons

    @IBOutlet weak var choice1Button: SAIAccessibleButton?

    @IBOutlet weak var choice2Button: SAIAccessibleButton?

    @IBOutlet weak var choice3Button: SAIAccessibleButton?

    @IBOutlet weak var choice4Button: SAIAccessibleButton?

    @IBOutlet weak var newGameButton: SAIAccessibleButton?

    // MARK: - @IBOutlets - Labels

	@IBOutlet weak var questionLabel: UILabel?
	
	@IBOutlet weak var scoreLabel: UILabel?

	@IBOutlet weak var secondsLeftLabel: UILabel?

    // MARK: - @IBOutlets - Other

	@IBOutlet weak var objectCollectionView: UICollectionView?

    // MARK: - Properties - Edge Insets

    private var objectInsets: UIEdgeInsets {
        let verticalInsets: CGFloat = 50
        let horizontalInsets: CGFloat = 20
        let insets = UIEdgeInsets(
            top: verticalInsets,
            left: horizontalInsets,
            bottom: verticalInsets,
            right: horizontalInsets)
        return insets
    }

    // MARK: - Properties - Floats

    private let choiceButtonTextSize: CGFloat = 50

    // MARK: - Properties - Objects

	var gameBrain = GameBrain.shared

    // MARK: - Properties - Inactivity VoiceOver Announcement Timer

	var announcementTimer: Timer? = nil

	// MARK: - Setup

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
        objectCollectionView?.dataSource = self
        objectCollectionView?.delegate = self
        objectCollectionView?.isUserInteractionEnabled = true
		navigationItem.hidesBackButton = true
        secondsLeftLabel?.text = "Loading…"
        scoreLabel?.isAccessibilityElement = true
		// Create gradient layer
		let gradientLayer = CAGradientLayer()
		gradientLayer.frame = view.bounds
		gradientLayer.colors = traitCollection.userInterfaceStyle == .dark ? gradientColorsDark : gradientColorsLight
		gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
		gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
		// Add gradient layer to view
		view.layer.insertSublayer(gradientLayer, at: 0)
        objectCollectionView?.backgroundColor = .clear
		newQuestion()
	}

    override func viewDidAppear(_ animated: Bool) {
		gameBrain.setupGameTimer { [self] time in
			if let time = time {
				let secondsSingularOrPlural = time == 1 ? "second" : "seconds"
                secondsLeftLabel?.text = "\(Int(time)) \(secondsSingularOrPlural) left"
			} else {
                secondsLeftLabel?.text = gameBrain.gameType == .play ? "Untimed" : "Practice"
			}
		} timerEndHandler: { [self] in
			performSegue(withIdentifier: "TimeUp", sender: self)
			gameBrain.playTimeUpSound()
		}
		super.viewDidAppear(animated)
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		gameBrain.resetGameTimer()
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

    // MARK: - Reset Game

	func resetGame() {
		gameBrain.resetGame()
		navigationController?.popToRootViewController(animated: true)
	}

    // MARK: - Stats Update

	func updateStatDisplay() {
        scoreLabel?.text = "\(gameBrain.correctAnswersInGame) out of \(gameBrain.triesInGame) tries correct"
	}

    // MARK: - New Question

	func newQuestion() {
		gameBrain.newQuestion()
        questionLabel?.text = gameBrain.getQuestionText()
		objectCollectionView?.accessibilityLabel = gameBrain.backgroundAccessibilityText
		setChoices()
		updateStatDisplay()
		objectCollectionView?.reloadData()
		resetAnnouncementTimer()
	}

	func setChoices() {
		let choices = gameBrain.getChoices()
		choice1Button?.setTitle(choices[0], for: .normal)
        choice1Button?.usesMonospacedFont = true
        choice1Button?.textSize = choiceButtonTextSize
		choice2Button?.setTitle(choices[1], for: .normal)
        choice2Button?.usesMonospacedFont = true
        choice2Button?.textSize = choiceButtonTextSize
		choice3Button?.setTitle(choices[2], for: .normal)
        choice3Button?.usesMonospacedFont = true
        choice3Button?.textSize = choiceButtonTextSize
		choice4Button?.setTitle(choices[3], for: .normal)
        choice4Button?.usesMonospacedFont = true
        choice4Button?.textSize = choiceButtonTextSize
	}

    // MARK: - @IBActions

	@IBAction func answerSelected(_ sender: SAIAccessibleButton) {
		guard let answer = sender.currentTitle else { return }
		let correct = gameBrain.checkAnswer(answer)
		let incorrectTooManyTimes = !correct && gameBrain.tooManyIncorrect
		updateStatDisplay()
		if correct {
			performSegue(withIdentifier: "Correct", sender: sender)
			newQuestion()
		} else if incorrectTooManyTimes {
			performSegue(withIdentifier: "TooManyIncorrect", sender: sender)
			newQuestion()
		} else {
			performSegue(withIdentifier: "Incorrect", sender: sender)
		}
	}

	@IBAction func newGame(_ sender: Any) {
		resetGame()
	}

	// MARK: - Navigation

	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// 1. Get the new view controller using segue.destination.
		// Pass the selected object to the new view controller.
		if let answerCheckViewController = segue.destination as? AnswerCheckViewController {
			switch segue.identifier {
                // 2. If segue is used to present the AnswerCheckViewController (sheet), set the messageText and imageName of the AnswerCheckViewController based on which segue is used to present it. The segue to use to present it depends on whether the chosen answer is correct, incorrect, or the 3rd incorrect one in a row.
				case "Incorrect":
					answerCheckViewController.messageText = "Incorrect! Try again!"
					answerCheckViewController.imageName = "x"
				case "TooManyIncorrect":
					answerCheckViewController.messageText = "Incorrect! The correct answer is \(gameBrain.getCorrectAnswer())."
					answerCheckViewController.imageName = "x"
				default:
					answerCheckViewController.messageText = "Correct!"
					answerCheckViewController.imageName = "checkmark"
			}
		} else if let timeUpViewController = segue.destination as? TimeUpViewController {
            // 3. If segue is used to present the TimeUpViewController (navigation), set the messageText of the TimeUpViewController.
			timeUpViewController.messageText = "Time's up! You answered \(gameBrain.correctAnswersInGame) of \(gameBrain.triesInGame) tries correct!"
		}
	}

    // MARK: - Inactivity VoiceOver Announcement

    func resetAnnouncementTimer() {
        #if targetEnvironment(macCatalyst)
        let message = "Starting from the top-left of the screen, move to each group of \(gameBrain.getDisplayNameForObject()) and count them, then if you'd like, activate to play the sound."
        #else
        let message = "Starting from the top-left of the screen, drag your finger accross each group of \(gameBrain.getDisplayNameForObject()) to count them, then if you'd like, split-tap (keep your finger on the screen and tap with a second) to play the sound."
        #endif
        let secondsToWait: TimeInterval = 15
        announcementTimer?.invalidate()
        announcementTimer = nil
        announcementTimer = Timer.scheduledTimer(withTimeInterval: secondsToWait, repeats: true, block: { [self] timer in
            guard presentedViewController == nil else { return }
            timer.invalidate()
            announcementTimer = nil
            speakVoiceOverMessage(message)
        })
    }

	func speakVoiceOverMessage(_ message: String) {
		UIAccessibility.post(notification: .announcement, argument: message)
	}

}

extension GameViewController {

	// MARK: - Collection View Delegate and Data Source

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		let number = gameBrain.numberOfImagesToShow
		return number
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ObjectCell", for: indexPath)
		// Create and configure the image view
			let imageView = ObjectImageView(frame: cell.contentView.bounds)
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
		tapGesture.numberOfTouchesRequired = 1
		tapGesture.numberOfTapsRequired = 1
		imageView.isUserInteractionEnabled = true
			imageView.image = UIImage(named: gameBrain.currentObject.name)
			imageView.contentMode = .scaleAspectFit
			imageView.clipsToBounds = true
			imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
			imageView.center = cell.contentView.center
		imageView.addGestureRecognizer(tapGesture)
		// Configure accessibility
		imageView.tag = indexPath.item + 1
		imageView.isAccessibilityElement = true
		imageView.accessibilityTraits = [.startsMediaSession, .image]
		imageView.accessibilityLabel = gameBrain.gameType == .play ? "\(gameBrain.imageAccessibilityText)" : "\(imageView.tag * gameBrain.currentObject.quantity)"
		#if targetEnvironment(macCatalyst)
		let soundGesture = "Activate"
		let moveGesture = "Move"
		#else
		let soundGesture = "Double-tap"
		let moveGesture = "Flick"
		#endif
		if indexPath.item == 0 {
			imageView.accessibilityHint = "\(soundGesture) if you want to play the sound for this group of objects."
		} else if indexPath.item == 4 && gameBrain.numberOfImagesToShow > 5 {
			imageView.accessibilityHint = "Now \(moveGesture) right to move to the second row."
		} else if indexPath.item == gameBrain.numberOfImagesToShow - 1 {
			imageView.accessibilityHint = "That's all the \(gameBrain.getDisplayNameForObject()), how many \(gameBrain.getDisplayNameForObject()) altogether? Select from the choices at the bottom of the screen."
		}
		cell.focusEffect = nil
		// Add the image view to the cell's content view
		cell.contentView.subviews.first?.removeFromSuperview()
			cell.contentView.addSubview(imageView)
		return cell
	}

	@objc func imageTapped(_ sender: UIGestureRecognizer) {
		if !UIAccessibility.isVoiceOverRunning && gameBrain.gameType == .practice {
			guard let image = sender.view as? ObjectImageView else { return }
			image.highlightBackground()
			gameBrain.speechSynthesizer.stopSpeaking(at: .immediate)
			gameBrain.speechSynthesizer.speak(AVSpeechUtterance(string: "\(image.tag * gameBrain.currentObject.quantity)"))
		}
		gameBrain.playSoundForObject()
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 30
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let paddingSpace = objectInsets.left * 2
		let availableWidth = view.frame.width - paddingSpace
		let widthPerItem = availableWidth / 6.2
		return CGSize(width: widthPerItem, height: widthPerItem)
	}


}
