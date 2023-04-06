//
//  ViewController.swift
//  SkippyNums
//
//  Created by TechWithTyler on 2/13/23.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {

	@IBOutlet weak var questionLabel: UILabel!
	
	@IBOutlet weak var scoreLabel: UILabel!
	
	@IBOutlet weak var objectCollectionView: UICollectionView!

	@IBOutlet weak var choice1Button: UIButton!

	@IBOutlet weak var choice2Button: UIButton!

	@IBOutlet weak var choice3Button: UIButton!

	@IBOutlet weak var choice4Button: UIButton!

	private let sectionInsets = UIEdgeInsets(
		top: 50.0,
		left: 20.0,
		bottom: 50.0,
		right: 20.0)

	private let gradientColorsLight: [CGColor] = [UIColor.systemRed.cgColor, UIColor.systemCyan.cgColor, UIColor.white.cgColor]

	private let gradientColorsDark: [CGColor] = [UIColor.systemPurple.cgColor, UIColor.black.cgColor]

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
		gameBrain.score = 0
		navigationController?.popViewController(animated: true)
	}

	func updateStatDisplay() {
		scoreLabel.text = "Score: \(gameBrain.score)"
	}

	func newQuestion() {
		gameBrain.newQuestion()
		questionLabel.text = gameBrain.getQuestionText()
		objectCollectionView.accessibilityLabel = gameBrain.backgroundAccessibilityText
		setChoices()
		setFonts()
		objectCollectionView.reloadData()
		updateStatDisplay()
		resetAnnouncementTimer()
	}

	func resetAnnouncementTimer() {
		#if targetEnvironment(macCatalyst)
		let message = "Move to each group of \(gameBrain.currentObject.name) and count them, then activate to play the sound."
		#else
		let message = "Drag your finger accross each group of \(gameBrain.currentObject.name) to count them, then double-tap to play the sound."
		#endif
		let secondsToWait: TimeInterval = 15
		announcementTimer = Timer.scheduledTimer(withTimeInterval: secondsToWait, repeats: false, block: { [self] timer in
			timer.invalidate()
			announcementTimer = nil
			UIAccessibility.post(notification: .announcement, argument: message)
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
				button.configuration?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
					var outgoing = incoming
					outgoing.font = UIFont.systemFont(ofSize: 40)
					return outgoing
				}
			}
		}
	}

	@IBAction func answerSelected(_ sender: UIButton) {
		guard let answer = sender.currentTitle else { return }
		let correct = gameBrain.checkAnswer(answer)
		let incorrectTooManyTimes = !correct && gameBrain.tooManyIncorrect
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
		guard let answerCheckViewController = segue.destination as? AnswerCheckViewController else { return }
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
	}

}

extension ViewController {

	// MARK: - Collection View Delegate and Data Source

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		let number = gameBrain.numberOfImagesToShow
		return number
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ObjectCell", for: indexPath)
		// Create and configure the image view
			let imageView = UIImageView(frame: cell.contentView.bounds)
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
		imageView.isAccessibilityElement = true
		imageView.accessibilityTraits = [.startsMediaSession, .image]
		imageView.accessibilityLabel = "\(gameBrain.imageAccessibilityText)"
		#if targetEnvironment(macCatalyst)
		let gesture = "Activate"
		#else
		let gesture = "Double-tap"
		#endif
		imageView.accessibilityHint = "\(gesture) to play the sound for this group of objects."
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

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let paddingSpace = sectionInsets.left * 4
		let availableWidth = view.frame.width - paddingSpace
		let widthPerItem = availableWidth / 5.5
		return CGSize(width: widthPerItem, height: widthPerItem)
	}


}
