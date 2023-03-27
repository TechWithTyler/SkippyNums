//
//  GameBrain.swift
//  Skippy
//
//  Created by TechWithTyler on 2/14/23.
//

import UIKit
import AVKit

struct GameBrain {

	// MARK: - Properties

	static var objects: [Object] = [
		// Comment out objects if they're not ready to commit or ship.
		Cow(),
		Elephant(),
		Car(),
		Airplane(),
//		Robot(),
//		Monkey(),
//		Bear()
	]

	var currentObject: Object

	var numberOfImagesToShow: Int = 2

	var score: Int = 0

	var soundPlayer: AVAudioPlayer? = nil

	var imageAccessibilityText: String {
		return "Group of \(currentObject.quantity) \(currentObject.name)"
	}

	var backgroundAccessibilityText: String {
		let groupSingularPlural = (numberOfImagesToShow == 1) ? "group" : "groups"
		return "\(numberOfImagesToShow) \(groupSingularPlural) of \(currentObject.quantity) \(currentObject.name)"
	}

	// MARK: - Game Logic

	init(currentObject: Object) {
		self.currentObject = currentObject
		do {
			try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
		} catch {
			fatalError("Error: \(error.localizedDescription)")
		}
	}

	mutating func newQuestion() {
		let countingBy = currentObject.quantity
		currentObject = GameBrain.objects.randomElement()!
		numberOfImagesToShow = Int.random(in: 2...10)
		soundPlayer?.stop()
	}

	func getQuestionText() -> String {
		let text = "Count the \(currentObject.name) by \(currentObject.quantity)s."
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
		return finalChoices
	}

	mutating func playSoundForObject() {
		guard let soundURL = Bundle.main.url(forResource: currentObject.soundFilename, withExtension: nil) else {
			fatalError("Failed to find \(currentObject.soundFilename) in bundle")
		}
		do {
			soundPlayer?.stop()
			soundPlayer = try AVAudioPlayer(contentsOf: soundURL)
			soundPlayer?.numberOfLoops = currentObject.quantity - 1
			soundPlayer?.enableRate = true
			soundPlayer?.rate = 2
			soundPlayer?.prepareToPlay()
			soundPlayer?.play()
		} catch {
			fatalError("Failed to play \(currentObject.soundFilename): \(error)")
		}
	}

	mutating func checkAnswer(_ answer: String) -> Bool {
		let correctAnswer = String(numberOfImagesToShow * currentObject.quantity)
		let correct = answer == correctAnswer
		playAnswerSound(correct)
		if correct {
			score += 1
		}
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
