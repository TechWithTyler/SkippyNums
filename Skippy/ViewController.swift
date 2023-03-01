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

	@IBOutlet weak var newQuestionButton: UIButton!

	var gameBrain = GameBrain(currentObject: GameBrain.objects.randomElement()!)

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		objectCollectionView.dataSource = self
		objectCollectionView.delegate = self
		newQuestion(self)
	}

	@IBAction func newQuestion(_ sender: Any) {
		print("New question")
		gameBrain.newQuestion(countingBy: 2)
		questionLabel.text = gameBrain.getQuestionText()
		setColors()
		setChoices()
		objectCollectionView.reloadData()
	}

	@IBAction func answerSelected(_ sender: UIButton) {
		guard let answer = sender.currentTitle else { return }
		let correct = gameBrain.checkAnswer(answer)
		if correct {
			print("Correct!")
		} else {
			print("Incorrect!")
		}
	}

	func setChoices() {
		choice1Button.setTitle("2", for: .normal)
		choice2Button.setTitle("4", for: .normal)
		choice3Button.setTitle("6", for: .normal)
		choice4Button.setTitle("8", for: .normal)
	}

	func setColors() {
		view.backgroundColor = gameBrain.getColors().background
		objectCollectionView.backgroundColor = gameBrain.getColors().background
		choice1Button.tintColor = gameBrain.getColors().buttons
		choice2Button.tintColor = gameBrain.getColors().buttons
		choice3Button.tintColor = gameBrain.getColors().buttons
		choice4Button.tintColor = gameBrain.getColors().buttons
		newQuestionButton.tintColor = gameBrain.getColors().buttons
	}

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		let number = gameBrain.numberOfObjectsToShow / gameBrain.groupsOfObjectsToShow
		print("Number of rows: \(number)")
		return number
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		let number = gameBrain.groupsOfObjectsToShow
		print("Number of objects in row \(section): \(number)")
		return number
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ObjectCell", for: indexPath)
		// Create and configure the image view
		let imageView = UIImageView(frame: cell.contentView.bounds)
		imageView.image = UIImage(named: gameBrain.currentObject.imageName)
		imageView.contentMode = .scaleAspectFit
		imageView.clipsToBounds = true
		imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		imageView.center = cell.contentView.center
		// Add the image view to the cell's content view
		cell.contentView.addSubview(imageView)
		return cell
	}


	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 20
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let numberOfObjectsInRow = gameBrain.groupsOfObjectsToShow
		let availableWidth = collectionView.bounds.width - collectionView.contentInset.left - collectionView.contentInset.right
		let cellWidth = (availableWidth - CGFloat(numberOfObjectsInRow - 1) * 15) / CGFloat(numberOfObjectsInRow)
		let numberOfRows = ceil(CGFloat(gameBrain.numberOfObjectsToShow) / CGFloat(numberOfObjectsInRow))
		let availableHeight = collectionView.bounds.height - collectionView.contentInset.top - collectionView.contentInset.bottom
		let cellHeight = (availableHeight - CGFloat(numberOfRows - 1) * 15) / CGFloat(numberOfRows)
		return CGSize(width: cellWidth, height: cellHeight)
	}


}
