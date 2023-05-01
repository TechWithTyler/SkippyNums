//
//  GameBrain.swift
//  SkippyNums
//
//  Created by TechWithTyler on 2/14/23.
//

import UIKit
import AVKit

class GameBrain {

	// MARK: - Properties

	static var shared: GameBrain = GameBrain(currentObject: GameBrain.objects.randomElement()!)

	static var objects: [any Object] = [
		// Comment out objects if they're not ready to commit or ship.
		Cow(),
		Elephant(),
		Car(),
		Airplane(),
		Bird(quantity: 2),
		Bird(quantity: 5),
		Robot(quantity: 2),
		Robot(quantity: 5),
		Monkey(quantity: 2),
		Monkey(quantity: 5),
		Monkey(quantity: 10),
		//		Bear()
	]

	var currentObject: any Object

	var numberOfImagesToShow: Int = 2

	var score: Int = 0

	var numberOfIncorrectAnswers = 0

	var countingBy: Int?

	var soundPlayer: AVAudioPlayer? = nil

	var tooManyIncorrect: Bool {
		return numberOfIncorrectAnswers == 3
	}

	var imageAccessibilityText: String {
		return "\(currentObject.quantity) \(getDisplayNameForObject())"
	}

	var backgroundAccessibilityText: String {
		return "\(numberOfImagesToShow) groups of \(currentObject.quantity) \(getDisplayNameForObject())"
	}

	// MARK: - Game Logic

	init(currentObject: Object) {
		self.currentObject = currentObject
	}

	func newQuestion() {
		let previousObjectName = currentObject.name
		let previousNumberOfImages = numberOfImagesToShow
		if countingBy == nil {
			currentObject = GameBrain.objects.randomElement()!
		} else {
			currentObject = GameBrain.objects.filter({$0.quantity == countingBy}).randomElement()!
		}
		let maxNumber = 10
		numberOfImagesToShow = Int.random(in: 2...maxNumber)
		numberOfIncorrectAnswers = 0
		if currentObject.name == previousObjectName && numberOfImagesToShow == previousNumberOfImages {
			// If the next question is identical to the previous one, try again until a different question is generated.
			newQuestion()
		}
	}

	func getDisplayNameForObject() -> String {
		return currentObject.name.filter { $0.isLetter }
	}

	func getQuestionText() -> String {
		var quantityWord: String {
			switch currentObject.quantity {
				case 5: return "fives"
				case 10: return "tens"
				default: return "twos"
			}
		}
		let text = "Count the \(getDisplayNameForObject()) by \(quantityWord)."
		return text
	}

	func getChoices() -> [String] {
		// Below correct answer
		let choice1 = numberOfImagesToShow * currentObject.quantity - (currentObject.quantity * 2)
		let choice2 = numberOfImagesToShow * currentObject.quantity - currentObject.quantity
		// Correct answer
		let correctChoice = numberOfImagesToShow * currentObject.quantity
		// Above correct answer
		let choice3 = numberOfImagesToShow * currentObject.quantity + currentObject.quantity
		let choice4 = numberOfImagesToShow * currentObject.quantity + (currentObject.quantity * 2)
		let shuffledIncorrectChoices = [String(choice1), String(choice2), String(choice3), String(choice4)].shuffled()
		var finalChoices = Array(shuffledIncorrectChoices.dropLast())
		finalChoices.append(String(correctChoice))
		finalChoices.shuffle()
		// Replace 0 with 1
		for i in 0...finalChoices.count - 1 {
			if finalChoices[i] == "0" {
				return [String(choice2), String(choice3), String(choice4), String(correctChoice)].shuffled()
			}
		}
		return finalChoices
	}

	func playSoundForObject() {
		guard let soundURL = Bundle.main.url(forResource: currentObject.soundFilename, withExtension: nil) else {
			fatalError("Failed to find \(currentObject.soundFilename) in bundle")
		}
		do {
			soundPlayer?.stop()
			soundPlayer = try AVAudioPlayer(contentsOf: soundURL)
			soundPlayer?.numberOfLoops = currentObject.quantity - 1
			soundPlayer?.enableRate = true
			soundPlayer?.rate = currentObject.soundRate
			soundPlayer?.volume = 1
			soundPlayer?.prepareToPlay()
			soundPlayer?.play()
		} catch {
			fatalError("Failed to play \(currentObject.soundFilename): \(error)")
		}
	}

	func playChord() {
		var filename: String {
			switch currentObject.quantity {
				case 10: return "tenChord"
				case 5: return "fiveChord"
				default: return "twoNote"
			}
		}
		guard let soundURL = Bundle.main.url(forResource: filename, withExtension: "caf") else {
			fatalError("Failed to find \(filename).caf in bundle")
		}
		do {
			soundPlayer?.stop()
			soundPlayer = try AVAudioPlayer(contentsOf: soundURL)
			soundPlayer?.volume = 0.25
			soundPlayer?.prepareToPlay()
			soundPlayer?.play()
		} catch {
			fatalError("Failed to play \(filename).caf: \(error)")
		}
	}

	func getCorrectAnswer() -> String {
		return String(numberOfImagesToShow * currentObject.quantity)
	}

	func checkAnswer(_ answer: String) -> Bool {
		let correctAnswer = getCorrectAnswer()
		let correct = answer == correctAnswer
		playAnswerSound(correct)
		if correct {
			score += 1
		} else {
			numberOfIncorrectAnswers += 1
		}
		return correct
	}

	func playAnswerSound(_ correct: Bool) {
		let filename = correct ? "correct.caf" : "incorrect.caf"
		guard let soundURL = Bundle.main.url(forResource: filename, withExtension: nil) else {
			fatalError("Failed to find \(filename) in bundle")
		}
		do {
			soundPlayer?.stop()
			soundPlayer = try AVAudioPlayer(contentsOf: soundURL)
			if !correct {
				soundPlayer?.enableRate = true
				soundPlayer?.rate = 0.5
			}
			soundPlayer?.volume = 1
			soundPlayer?.prepareToPlay()
			soundPlayer?.play()
		} catch {
			fatalError("Failed to play \(filename): \(error)")
		}
	}

}
