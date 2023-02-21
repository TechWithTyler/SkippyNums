//
//  ViewController.swift
//  Skipy
//
//  Created by Tyler Sheft on 2/13/23.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var questionLabel: UILabel!

	@IBOutlet weak var objectImageView: UIImageView!

	@IBOutlet weak var choice1Button: UIButton!

	@IBOutlet weak var choice2Button: UIButton!

	@IBOutlet weak var choice3Button: UIButton!

	@IBOutlet weak var choice4Button: UIButton!

	var gameBrain = GameBrain(currentObject: GameBrain.objects.randomElement()!)

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		newQuestion()
	}

	func newQuestion() {
		gameBrain.newQuestion(countingBy: 2)
		questionLabel.text = gameBrain.getQuestionText()
		setColors()
		setChoices()
		showGroupsOfObjects(object: gameBrain.currentObject, total: gameBrain.numberOfObjectsToShow, groups: gameBrain.groupsOfObjectsToShow)
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

	func showGroupsOfObjects(object: Object, total: Int, groups: Int) {
		guard let image = UIImage(named: object.imageName) else { return }
		let objectsPerGroup = total/groups
		let screenWidth = objectImageView.bounds.width
		let maxObjectsPerRow = Int(screenWidth / (image.size.width + 10))
		let objectsPerRow = min(objectsPerGroup, maxObjectsPerRow)
		let rowsPerGroup = Int(ceil(Double(objectsPerGroup) / Double(objectsPerRow)))
		for groupIndex in 0..<groups {
			let startingIndex = groupIndex * objectsPerGroup + 1
			let endingIndex = min((groupIndex + 1) * objectsPerGroup, total)
			let objectsInGroup = endingIndex - startingIndex + 1
			let rowsInGroup = Int(ceil(Double(objectsInGroup) / Double(objectsPerRow)))
			let groupWidth = CGFloat(min(objectsInGroup, objectsPerRow)) * (image.size.width + 10) - 10
			let groupOffsetX = (screenWidth - groupWidth) / 2.0
			let groupOffsetY = CGFloat(groupIndex * rowsPerGroup) * (image.size.height + 10)
			for i in startingIndex...endingIndex {
				let newImageView = UIImageView(image: image)
				let objectIndex = i - startingIndex
				let row = objectIndex / objectsPerRow
				let col = objectIndex % objectsPerRow
				let x = groupOffsetX + CGFloat(col) * (image.size.width + 10)
				let y = groupOffsetY + CGFloat(row) * (image.size.height + 10)
				newImageView.frame = CGRect(x: x, y: y, width: image.size.width, height: image.size.height)
				objectImageView.addSubview(newImageView)
			}
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
		choice1Button.tintColor = gameBrain.getColors().buttons
		choice2Button.tintColor = gameBrain.getColors().buttons
		choice3Button.tintColor = gameBrain.getColors().buttons
		choice4Button.tintColor = gameBrain.getColors().buttons
	}

	func clearImageView() {
		for view in objectImageView.subviews {
			view.removeFromSuperview()
		}
	}


}

