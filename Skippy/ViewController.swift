//
//  ViewController.swift
//  Skippy
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

	private let gradientColorsLight: [CGColor] = [UIColor.systemRed.cgColor, UIColor.systemCyan.cgColor]

	private let gradientColorsDark: [CGColor] = [UIColor.systemPurple.cgColor, UIColor.black.cgColor]

	var gameBrain = GameBrain(currentObject: GameBrain.objects.randomElement()!)

	// MARK: - Setup

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		objectCollectionView.dataSource = self
		objectCollectionView.delegate = self
		objectCollectionView.isUserInteractionEnabled = true
		resetStats()
		newQuestion()
		// Create gradient layer
		let gradientLayer = CAGradientLayer()
		gradientLayer.frame = view.bounds
		gradientLayer.colors = traitCollection.userInterfaceStyle == .dark ? gradientColorsDark : gradientColorsLight
		gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
		gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
		// Add gradient layer to view
		view.layer.insertSublayer(gradientLayer, at: 0)
		objectCollectionView.backgroundColor = .clear
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
		let newGameAlert = UIAlertController(title: "Start a new game?", message: "Your progress will be lost!", preferredStyle: .alert)
		let newGameAction = UIAlertAction(title: "Yes", style: .default) { [self] action in
			resetStats()
			newQuestion()
		}
		let cancelAction = UIAlertAction(title: "No", style: .cancel)
		newGameAlert.addAction(newGameAction)
		newGameAlert.addAction(cancelAction)
		present(newGameAlert, animated: true)
	}

	func resetStats() {
		gameBrain.score = 0
		updateStatDisplay()
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
		let condition = correct ? "Correct!" : "Incorrect!"
		let alert = UIAlertController(title: condition, message: nil, preferredStyle: .alert)
		updateStatDisplay()
		if correct {
			let newQuestionAction = UIAlertAction(title: "Next Question", style: .default) {
				[self] action in
				newQuestion()
			}
			alert.addAction(newQuestionAction)
		} else {
			let okAction = UIAlertAction(title: "Try Again", style: .default)
			alert.addAction(okAction)
		}
		present(alert, animated: true)
	}

}

extension ViewController {

	// MARK: - Collection View Delegate and Data Source

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		// Columns
		let number = gameBrain.numberOfImagesToShow
		print("Number of objects in row \(section): \(number)")
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
