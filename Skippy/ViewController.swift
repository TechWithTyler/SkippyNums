//
//  ViewController.swift
//  Skipy
//
//  Created by Tyler Sheft on 2/13/23.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {

	@IBOutlet weak var questionLabel: UILabel!
	
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

	var gameBrain = GameBrain(currentObject: GameBrain.objects.randomElement()!)

	// MARK: - Setup

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		objectCollectionView.dataSource = self
		objectCollectionView.delegate = self
		objectCollectionView.isUserInteractionEnabled = true
		newQuestion()
	}

	func newQuestion() {
		gameBrain.newQuestion()
		questionLabel.text = gameBrain.getQuestionText()
		objectCollectionView.accessibilityLabel = gameBrain.backgroundAccessibilityText
		setChoices()
		setFontsAndColors()
		objectCollectionView.reloadData()
	}

	func setChoices() {
		let choices = gameBrain.getChoices()
		choice1Button.setTitle("\(choices[0])", for: .normal)
		choice2Button.setTitle("\(choices[1])", for: .normal)
		choice3Button.setTitle("\(choices[2])", for: .normal)
		choice4Button.setTitle("\(choices[3])", for: .normal)
	}

	func setFontsAndColors() {
		for view in view.subviews {
			if let button = view as? UIButton {
				button.configuration?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
					var outgoing = incoming
					outgoing.font = UIFont.systemFont(ofSize: 40)
					return outgoing
				}
			}
		}
//		view.backgroundColor = gameBrain.getColors().background
//		objectCollectionView.backgroundColor = gameBrain.getColors().background
//		choice1Button.tintColor = gameBrain.getColors().buttons
//		choice2Button.tintColor = gameBrain.getColors().buttons
//		choice3Button.tintColor = gameBrain.getColors().buttons
//		choice4Button.tintColor = gameBrain.getColors().buttons
	}

	@IBAction func answerSelected(_ sender: UIButton) {
		guard let answer = sender.currentTitle else { return }
		let correct = gameBrain.checkAnswer(answer)
		let condition = correct ? "Correct!" : "Incorrect!"
		let alert = UIAlertController(title: condition, message: nil, preferredStyle: .alert)
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
		let number = gameBrain.numberOfObjectsToShow
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
			imageView.image = UIImage(named: gameBrain.currentObject.imageName)
			imageView.contentMode = .scaleAspectFit
			imageView.clipsToBounds = true
			imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
			imageView.center = cell.contentView.center
		imageView.addGestureRecognizer(tapGesture)
		imageView.isAccessibilityElement = true
		imageView.accessibilityLabel = gameBrain.objectAccessibilityText
			// Add the image view to the cell's content view
		cell.contentView.subviews.first?.removeFromSuperview()
			cell.contentView.addSubview(imageView)
		return cell
	}

	@objc func imageTapped(_ sender: UITapGestureRecognizer) {
		gameBrain.playSoundForObject()
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let paddingSpace = sectionInsets.left * 4
		let availableWidth = view.frame.width - paddingSpace
		let widthPerItem = availableWidth / 5.5
		return CGSize(width: widthPerItem, height: widthPerItem)
	}


}
