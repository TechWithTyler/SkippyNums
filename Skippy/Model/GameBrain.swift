//
//  GameBrain.swift
//  Skippy
//
//  Created by Tyler Sheft on 2/14/23.
//

import UIKit

struct GameBrain {

	// MARK: - Properties

	static var objects: [Object] = [
		Cherry()
		// Add more objects here
	]

	var currentObject: Object

	var numberOfObjectsToShow: Int = 2

	func getLayout() -> (rows: Int, columns: Int) {
		let columns: Int
		let rows: Int
		switch numberOfObjectsToShow {
			case 4...6:
				columns = 3
				rows = 2
			default:
				// 1...3
				columns = numberOfObjectsToShow
				rows = 1
		}
		return (rows: rows, columns: columns)
	}

	// MARK: - Game Logic

	mutating func newQuestion(countingBy: Int) {
		let countingBy = currentObject.quantity
		currentObject = GameBrain.objects.randomElement()!
		numberOfObjectsToShow = Int.random(in: 1*countingBy...4*countingBy)
	}

	func getQuestionText() -> String {
		let text = "How many \(currentObject.displayPluralName) are there?"
		return text
	}

	func getColors() -> (background: UIColor, buttons: UIColor) {
		return (background: currentObject.backgroundColor, buttons: currentObject.buttonColor)
	}

	func getChoices() -> [String] {
		let choice1 = numberOfObjectsToShow * currentObject.quantity / 8
		let choice2 = numberOfObjectsToShow * currentObject.quantity / 4
		let choice3 = numberOfObjectsToShow * currentObject.quantity / 2
		let choice4 = numberOfObjectsToShow * currentObject.quantity
		let shuffledChoices = [String(choice1), String(choice2), String(choice3), String(choice4)].shuffled()
		return shuffledChoices
	}

	func checkAnswer(_ answer: String) -> Bool {
		let correctAnswer = String(numberOfObjectsToShow * currentObject.quantity)
		print("Comparing answer \(answer) to correct \(correctAnswer)")
		if answer == correctAnswer {
			return true
		} else {
			return false
		}
	}

}
