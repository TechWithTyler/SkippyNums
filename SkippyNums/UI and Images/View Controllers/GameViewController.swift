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

	// MARK: - View Setup/Update

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
            // This block is still used for untimed/practice games--the block is called immediately and no timer is started.
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
        scoreLabel?.text = "\(gameBrain.correctAnswersInGame) out of \(gameBrain.triesSingularOrPlural) correct"
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
        // 1. Convert the Int array of choices to String using map. Converting an array's elements from one type to another is a common use of map (when you don't want to throw out nil results) or compactMap (when you want to throw out nil results).
        let choices = gameBrain.getChoices().map { String($0) }
        // 2. Set each choice button's title to the corresponding item in the choices array, and set the font properties.
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
        // 1. Check whether the selected answer is correct, incorrect, or the 3rd incorrect one in a row.
		guard let answer = sender.currentTitle else { return }
		let correct = gameBrain.checkAnswer(answer)
		let incorrectTooManyTimes = !correct && gameBrain.tooManyIncorrect
		// 2. Update the stat display.
        updateStatDisplay()
        // 3. Choose the sheet to show and decide whether to advance to a new question based on whether the answer is correct, incorrect, or the 3rd incorrect one in a row.
		if correct {
            // Correct answer, advance to new question
			performSegue(withIdentifier: "Correct", sender: sender)
			newQuestion()
		} else if incorrectTooManyTimes {
            // 3rd incorrect answer in a row, advance to new question
			performSegue(withIdentifier: "TooManyIncorrect", sender: sender)
			newQuestion()
		} else {
            // Incorrect answer, don't advance to new question
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
                // The "correct or incorrect" image's name is always "something.circle", so we only pass that something to AnswerCheckViewController which constructs the full image name.
				case "Incorrect":
					answerCheckViewController.messageText = "Incorrect! Try again!"
					answerCheckViewController.baseImageName = "x"
				case "TooManyIncorrect":
					answerCheckViewController.messageText = "Incorrect! The correct answer is \(gameBrain.getCorrectAnswer())."
					answerCheckViewController.baseImageName = "x"
				default:
					answerCheckViewController.messageText = "Correct!"
					answerCheckViewController.baseImageName = "checkmark"
			}
		} else if let timeUpViewController = segue.destination as? TimeUpViewController {
            // 3. If segue is used to present the TimeUpViewController (navigation), set the messageText of the TimeUpViewController.
			timeUpViewController.messageText = "Time's up! You answered \(gameBrain.scoreText)!"
		}
	}

    // MARK: - Inactivity VoiceOver Announcement

    func resetAnnouncementTimer() {
        #if targetEnvironment(macCatalyst)
        let message = "Starting from the top-left of the screen, move to each group of \(gameBrain.getDisplayNameForObject()) and count them, then if you'd like, activate to play the sound."
        #else
        let message = "Starting from the top-left of the screen, drag your finger across each group of \(gameBrain.getDisplayNameForObject()) to count them, then if you'd like, split-tap (keep your finger on the screen and tap with a second) to play the sound."
        #endif
        let secondsToWait: TimeInterval = 15
        announcementTimer?.invalidate()
        announcementTimer = nil
        announcementTimer = Timer.scheduledTimer(withTimeInterval: secondsToWait, repeats: true) { [self] timer in
            guard presentedViewController == nil else { return }
            timer.invalidate()
            announcementTimer = nil
            speakVoiceOverMessage(message)
        }
    }

	func speakVoiceOverMessage(_ message: String) {
		UIAccessibility.post(notification: .announcement, argument: message)
	}

}

extension GameViewController {

	// MARK: - Collection View - Delegate and Data Source

    // Specifies the number of images to show.
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		let number = gameBrain.numberOfImagesToShow
		return number
	}

    // Shows an image in the collection view cell.
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ObjectCell", for: indexPath)
		// 1. Create and configure the image view.
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
		// 2. Configure accessibility.
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
            imageView.accessibilityHint = "\(soundGesture) if you want to play the sound for this group of \(gameBrain.getDisplayNameForObject())."
		} else if indexPath.item == 4 && gameBrain.numberOfImagesToShow > 5 {
			imageView.accessibilityHint = "Now \(moveGesture) right to move to the second row."
		} else if indexPath.item == gameBrain.numberOfImagesToShow - 1 {
			imageView.accessibilityHint = "That's all the \(gameBrain.getDisplayNameForObject()), how many \(gameBrain.getDisplayNameForObject()) altogether? Select from the choices at the bottom of the screen."
		}
		cell.focusEffect = nil
		// 3. Add the image view to the cell's content view.
		cell.contentView.subviews.first?.removeFromSuperview()
			cell.contentView.addSubview(imageView)
		return cell
	}

    // Specifies spacing between the images in the collection view.
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let sectionSpacing: CGFloat = 30
		return sectionSpacing
	}

    // Specifies sizing of the images in the collection view.
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let paddingSpace = objectInsets.left * 2
		let availableWidth = view.frame.width - paddingSpace
		let widthPerItem = availableWidth / 6.2
		return CGSize(width: widthPerItem, height: widthPerItem)
	}

    // MARK: - Collection View - Image Activation Handler

    @objc func imageTapped(_ sender: UIGestureRecognizer) {
        // 1. If in practice mode and VoiceOver is off, get the tapped image view and its tag (representing the skip count number) and use a dedicated speech synthesizer/highlight effect.
        if !UIAccessibility.isVoiceOverRunning && gameBrain.gameType == .practice {
            guard let image = sender.view as? ObjectImageView else { return }
            let skipCountNumber = image.tag * gameBrain.currentObject.quantity
            image.highlightBackground()
            gameBrain.speechSynthesizer.stopSpeaking(at: .immediate)
            gameBrain.speechSynthesizer.speak(AVSpeechUtterance(string: String(skipCountNumber)))
        }
        // 2. Play the object's sound (e.g., "moo, moo" for a group of 2 cows or "woof, woof, woof, woof, woof" for a group of 5 dogs).
        gameBrain.playSoundForObject()
    }

}
