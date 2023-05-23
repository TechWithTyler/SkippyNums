//
//  GameViewController.swift
//  SkippyNums
//
//  Created by TechWithTyler on 2/13/23.
//

import UIKit

class GameViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {

	@IBOutlet weak var questionLabel: UILabel!
	
	@IBOutlet weak var scoreLabel: UILabel!

	@IBOutlet weak var secondsLeftLabel: UILabel!
	
	@IBOutlet weak var objectCollectionView: UICollectionView!

	@IBOutlet weak var choice1Button: UIButton!

	@IBOutlet weak var choice2Button: UIButton!

	@IBOutlet weak var choice3Button: UIButton!

	@IBOutlet weak var choice4Button: UIButton!
	
	@IBOutlet weak var newGameButton: UIButton!
	
	private let sectionInsets = UIEdgeInsets(
		top: 50.0,
		left: 20.0,
		bottom: 50.0,
		right: 20.0)

	

	var gameBrain = GameBrain.shared

	var announcementTimer: Timer? = nil

	// MARK: - Setup

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		objectCollectionView.dataSource = self
		objectCollectionView.delegate = self
		objectCollectionView.isUserInteractionEnabled = true
		navigationItem.hidesBackButton = true
		secondsLeftLabel.text = "Loading…"
		scoreLabel.isAccessibilityElement = true
		// Create gradient layer
		let gradientLayer = CAGradientLayer()
		gradientLayer.frame = view.bounds
		gradientLayer.colors = traitCollection.userInterfaceStyle == .dark ? gradientColorsDark : gradientColorsLight
		gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
		gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
		// Add gradient layer to view
		view.layer.insertSublayer(gradientLayer, at: 0)
		objectCollectionView.backgroundColor = .clear
		newQuestion()
	}

	override func viewDidAppear(_ animated: Bool) {
		gameBrain.setupGameTimer { [self] time in
			if let time = time {
				let secondsSingularOrPlural = time == 1 ? "second" : "seconds"
				secondsLeftLabel.text = "\(Int(time)) \(secondsSingularOrPlural) left"
			} else {
				secondsLeftLabel.text = "Untimed"
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
		gameBrain.objectsCountedWithVoiceOverSoFar.removeAll()
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

	@IBAction func newGame(_ sender: Any) {
		resetGame()
	}

	func resetGame() {
		gameBrain.soundPlayer?.stop()
		gameBrain.correctAnswersInGame = 0
		gameBrain.triesInGame = 0
		navigationController?.popToRootViewController(animated: true)
	}

	func updateStatDisplay() {
		scoreLabel.text = "\(gameBrain.correctAnswersInGame) out of \(gameBrain.triesInGame) tries correct"
	}

	func newQuestion() {
		gameBrain.newQuestion()
		questionLabel.text = gameBrain.getQuestionText()
		objectCollectionView.accessibilityLabel = gameBrain.backgroundAccessibilityText
		setChoices()
		setFonts()
		updateStatDisplay()
		objectCollectionView.reloadData()
		resetAnnouncementTimer()
	}

	func resetAnnouncementTimer() {
		#if targetEnvironment(macCatalyst)
		let message = "Move to each group of \(gameBrain.getDisplayNameForObject()) and count them, then if you'd like, activate to play the sound."
		#else
		let message = "Drag your finger accross each group of \(gameBrain.getDisplayNameForObject()) to count them, then if you'd like, split-tap (keep your finger on the screen and tap with a second) to play the sound."
		#endif
		let secondsToWait: TimeInterval = 15
		announcementTimer = Timer.scheduledTimer(withTimeInterval: secondsToWait, repeats: true, block: { [self] timer in
			guard presentedViewController == nil else { return }
			timer.invalidate()
			announcementTimer = nil
			speakVoiceOverMessage(message)
		})
	}

	func setChoices() {
		let choices = gameBrain.getChoices()
		choice1Button.setTitle(choices[0], for: .normal)
		choice2Button.setTitle(choices[1], for: .normal)
		choice3Button.setTitle(choices[2], for: .normal)
		choice4Button.setTitle(choices[3], for: .normal)
	}

	func setFonts() {
		for view in view.subviews {
			if let button = view as? UIButton {
				if button != newGameButton {
					button.configuration?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
						var outgoing = incoming
						outgoing.font = UIFont(name: "Verdana", size: 50)
						return outgoing
					}
				}
				button.layer.shadowColor = UIColor.black.cgColor
				button.layer.shadowOffset = CGSize(width: 2, height: 2)
				button.layer.shadowOpacity = 0.5
				button.layer.shadowRadius = 4
			}
		}
	}

	@IBAction func answerSelected(_ sender: UIButton) {
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

	// MARK: - Navigation

	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// Get the new view controller using segue.destination.
		// Pass the selected object to the new view controller.
		if let answerCheckViewController = segue.destination as? AnswerCheckViewController {
			switch segue.identifier {
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
			timeUpViewController.messageText = "Time's up! You answered \(gameBrain.correctAnswersInGame) of \(gameBrain.triesInGame) tries correct!"
		}
	}

	func speakVoiceOverMessage(_ message: String) {
		UIAccessibility.post(notification: .announcement, argument: message)
	}

}

class ObjectImageView: UIImageView {

	override func accessibilityElementDidBecomeFocused() {
		super.accessibilityElementDidBecomeFocused()
		GameBrain.shared.playChord()

		// Find the view controller that contains this image view
		var responder: UIResponder? = self
		while let next = responder?.next {
			responder = next
			if let viewController = responder as? GameViewController {
				// Reset the VoiceOver announcement timer
				viewController.announcementTimer?.invalidate()
				viewController.announcementTimer = nil
				break
			}
		}

		if !GameBrain.shared.objectsCountedWithVoiceOverSoFar.contains(tag) {
			GameBrain.shared.objectsCountedWithVoiceOverSoFar.append(tag)
		}

		print("Objects counted so far: \(GameBrain.shared.objectsCountedWithVoiceOverSoFar.count), tag of image: \(tag), images: \(GameBrain.shared.numberOfImagesToShow)")

		if GameBrain.shared.objectsCountedWithVoiceOverSoFar.contains(tag) && GameBrain.shared.numberOfImagesToShow == GameBrain.shared.objectsCountedWithVoiceOverSoFar.count {
			UIAccessibility.post(notification: .pauseAssistiveTechnology, argument: UIAccessibility.AssistiveTechnologyIdentifier.notificationVoiceOver)
			accessibilityHint = "That's all the \(GameBrain.shared.getDisplayNameForObject()), how many \(GameBrain.shared.getDisplayNameForObject()) altogether? Select from the choices at the bottom of the screen."
			UIAccessibility.post(notification: .resumeAssistiveTechnology, argument: UIAccessibility.AssistiveTechnologyIdentifier.notificationVoiceOver)
		}
	}

	@objc func announceCompletion() {
		print("Announcing")
		NotificationCenter.default.removeObserver(self, name: UIAccessibility.announcementDidFinishNotification, object: nil)
		UIAccessibility.post(notification: .announcement , argument: "That's all the \(GameBrain.shared.getDisplayNameForObject()), how many \(GameBrain.shared.getDisplayNameForObject()) altogether? Select from the choices at the bottom of the screen.")
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
		imageView.isUserInteractionEnabled = true
		tapGesture.numberOfTouchesRequired = 1
		tapGesture.numberOfTapsRequired = 1
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
		imageView.accessibilityLabel = "\(gameBrain.imageAccessibilityText)"
		#if targetEnvironment(macCatalyst)
		let gesture = "Activate"
		#else
		let gesture = "Double-tap"
		#endif
		if indexPath.item == 0 {
			imageView.accessibilityHint = "\(gesture) if you want to play the sound for this group of objects."
		}
		cell.focusEffect = nil
		// Add the image view to the cell's content view
		cell.contentView.subviews.first?.removeFromSuperview()
			cell.contentView.addSubview(imageView)
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, canPerformPrimaryActionForItemAt indexPath: IndexPath) -> Bool {
		imageTapped(collectionView)
		return true
	}

	@objc func imageTapped(_ sender: Any) {
		gameBrain.playSoundForObject()
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 30
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let paddingSpace = sectionInsets.left * 2
		let availableWidth = view.frame.width - paddingSpace
		let widthPerItem = availableWidth / 6.2
		return CGSize(width: widthPerItem, height: widthPerItem)
	}


}
