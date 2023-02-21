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

	var countingBy: Int = 2

	var numberOfObjectsToShow: Int = Int.random(in: 1...10)

	lazy var groupsOfObjectsToShow: Int = {
		return numberOfObjectsToShow / countingBy
	}()

	// MARK: - Game Logic

	mutating func newQuestion(countingBy: Int) {
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
