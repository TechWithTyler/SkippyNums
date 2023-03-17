//
//  GameBrain.swift
//  Skippy
//
//  Created by Tyler Sheft on 2/14/23.
//

import UIKit
import AVKit

struct GameBrain {

	// MARK: - Properties

	static var objects: [Object] = [
		Cow(),
		Elephant(),
		Car()
	]

	var currentObject: Object

	var numberOfObjectsToShow: Int = 2

	var soundPlayer: AVAudioPlayer? = nil

	var objectAccessibilityText: String {
		return "Group of \(currentObject.quantity) \(currentObject.displayPluralName)"
	}

	var backgroundAccessibilityText: String {
		let groupSingularPlural = (numberOfObjectsToShow == 1) ? "group" : "groups"
		return "\(numberOfObjectsToShow) \(groupSingularPlural) of \(currentObject.quantity) \(currentObject.displayPluralName)"
	}

	// MARK: - Game Logic

	mutating func newQuestion() {
		let countingBy = currentObject.quantity
		currentObject = GameBrain.objects.randomElement()!
		numberOfObjectsToShow = Int.random(in: 1*countingBy...5*countingBy)
		soundPlayer?.stop()
	}

	func getQuestionText() -> String {
		let text = "Count the \(currentObject.displayPluralName) by \(currentObject.quantity)s."
		return text
	}

	func getChoices() -> [String] {
		// Below correct answer
		let choice1 = numberOfObjectsToShow * currentObject.quantity / 4
		let choice2 = numberOfObjectsToShow * currentObject.quantity / 2
		// Correct answer
		let choice3 = numberOfObjectsToShow * currentObject.quantity
		// Above correct answer
		let choice4 = numberOfObjectsToShow * currentObject.quantity * 2
		let shuffledChoices = [String(choice1), String(choice2), String(choice3), String(choice4)].shuffled()
		return shuffledChoices
	}

	mutating func playSoundForObject() {
		guard let soundURL = Bundle.main.url(forResource: currentObject.soundFilename, withExtension: nil) else {
			fatalError("Failed to find \(currentObject.soundFilename) in bundle")
		}
		do {
			soundPlayer?.stop()
			soundPlayer = try AVAudioPlayer(contentsOf: soundURL)
			soundPlayer?.numberOfLoops = currentObject.quantity - 1
			soundPlayer?.prepareToPlay()
			soundPlayer?.play()
		} catch {
			fatalError("Failed to play \(currentObject.soundFilename): \(error)")
		}
	}

	mutating func checkAnswer(_ answer: String) -> Bool {
		let correctAnswer = String(numberOfObjectsToShow * currentObject.quantity)
		let correct = answer == correctAnswer
		playAnswerSound(correct)
		return correct
	}

	mutating func playAnswerSound(_ correct: Bool) {
		let filename = correct ? "correct.caf" : "incorrect.caf"
		guard let soundURL = Bundle.main.url(forResource: filename, withExtension: nil) else {
			fatalError("Failed to find \(filename) in bundle")
		}
		do {
			soundPlayer?.stop()
			soundPlayer = try AVAudioPlayer(contentsOf: soundURL)
			soundPlayer?.prepareToPlay()
			soundPlayer?.play()
		} catch {
			fatalError("Failed to play \(filename): \(error)")
		}
	}

}
