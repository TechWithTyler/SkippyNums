//
//  LearnViewController.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 8/3/23.
//

import UIKit

class LearnViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {

	@IBOutlet weak var questionLabel: UILabel!

	@IBOutlet weak var objectCollectionView: UICollectionView!

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
		super.viewDidAppear(animated)
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
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

	func resetGame() {
		gameBrain.resetGame()
		navigationController?.popToRootViewController(animated: true)
	}

	func newQuestion() {
		gameBrain.newQuestion()
		questionLabel.text = gameBrain.getQuestionText()
		objectCollectionView.accessibilityLabel = gameBrain.backgroundAccessibilityText
		setFonts()
		objectCollectionView.reloadData()
		resetAnnouncementTimer()
	}

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

	@IBAction func newGame(_ sender: Any) {
		resetGame()
	}

	// MARK: - Navigation

	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// Get the new view controller using segue.destination.
		// Pass the selected object to the new view controller.

	}

	func speakVoiceOverMessage(_ message: String) {
		UIAccessibility.post(notification: .announcement, argument: message)
	}

}

extension LearnViewController {

	// MARK: - Collection View Delegate and Data Source

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		let number = gameBrain.numberOfImagesToShow
		return number
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ObjectCellLearn", for: indexPath)
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