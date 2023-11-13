//
//  GameBrain.swift
//  SkippyNums
//
//  Created by TechWithTyler on 2/14/23.
//

import UIKit
import AVKit

class GameBrain {

	// MARK: - Game Type Enum

	enum GameType {
		
		case play

		case practice

		case learn

	}

	// MARK: - Properties - Shared GameBrain

	static var shared: GameBrain = GameBrain(currentObject: GameBrain.objects.randomElement()!)

	// MARK: - Properties - Objects to Count

	static var objects: [any Object] = [
		// Comment out objects if they're not ready to commit or ship.
		// Twos
		Cow(),
		Elephant(),
		Car(),
		Bird(quantity: 2),
		Robot(quantity: 2),
		Monkey(quantity: 2),
		// Fives
		Airplane(),
		Bird(quantity: 5),
		Robot(quantity: 5),
		Monkey(quantity: 5),
		// Tens
		Bird(quantity: 10),
		Monkey(quantity: 10),
		//		Bear()
	]

	// MARK: - Properties - Speech Synthesizer

	var speechSynthesizer = AVSpeechSynthesizer()

	// MARK: - Properties - Settings Data

	var settingsData = SettingsData()

	// MARK: - Properties - Game Type

	var gameType: GameType? = nil

	// MARK: - Properties - Current Object

	var currentObject: any Object

	// MARK: - Properties - Integers

	var numberOfImagesToShow: Int = 2

	var correctAnswersInGame: Int = 0

	var triesInGame: Int = 0

	var numberOfIncorrectAnswers = 0
	
	var countingBy: Int?

	// MARK: - Properties - Time Intervals

	var gameTimeLeft: TimeInterval? = nil

	// MARK: - Properties - Game Timer

	var gameTimer: Timer? = nil

	// MARK: - Properties - Lean Mode Numbers

	let learnModeNumbers: [Int] = [2, 5, 10]

	// MARK: - Properties - Sound Player

	var soundPlayer: AVAudioPlayer? = nil

	// MARK: - Properties - Booleans

	var isNewRoundInCurrentGame: Bool = false

	var tooManyIncorrect: Bool {
		return numberOfIncorrectAnswers == 3
	}

	// MARK: - Properties - Strings

	var imageAccessibilityText: String {
		return "\(currentObject.quantity) \(getDisplayNameForObject())"
	}

	var backgroundAccessibilityText: String {
		let normalString = "\(numberOfImagesToShow) groups of \(currentObject.quantity) \(getDisplayNameForObject())"
		if gameType == .learn {
			var learnString = "There are \(numberOfImagesToShow) groups of \(currentObject.quantity) \(getDisplayNameForObject()): "
			for n in 1...numberOfImagesToShow {
				learnString.append("\(n*currentObject.quantity)")
				if n != numberOfImagesToShow {
					learnString.append(", ")
				}
			}
			learnString.append(". There are \(numberOfImagesToShow*currentObject.quantity) \(getDisplayNameForObject()) altogether.")
			return learnString
		} else {
			return normalString
		}
	}

	// MARK: - Initialization

	init(currentObject: Object) {
		self.currentObject = currentObject
	}

	// MARK: - Lean Mode

	func startMonkeyLearnMode() {
		currentObject = Monkey(quantity: countingBy ?? learnModeNumbers.randomElement()!)
	}

	func startBirdLearnMode() {
		currentObject = Bird(quantity: countingBy ?? learnModeNumbers.randomElement()!)
	}

	// MARK: - New Question

	func newQuestion() {
		let maxNumber = settingsData.tenFrame ? 10 : 5
		numberOfImagesToShow = Int.random(in: 2...maxNumber)
		numberOfIncorrectAnswers = 0
		if gameType == .learn {
			if currentObject is Monkey {
				startMonkeyLearnMode()
			} else {
				startBirdLearnMode()
			}
		} else {
			let previousObjectName = currentObject.name
			let previousNumberOfImages = numberOfImagesToShow
			if countingBy == nil {
				currentObject = GameBrain.objects.randomElement()!
			} else {
				currentObject = GameBrain.objects.filter({$0.quantity == countingBy}).randomElement()!
			}
			if currentObject.name == previousObjectName && numberOfImagesToShow == previousNumberOfImages {
				// If the next question is identical to the previous one, try again until a different question is generated.
				newQuestion()
			}
		}
	}

	// MARK: - Get Data to Display

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
		return gameType != .learn ? text : backgroundAccessibilityText
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

	// MARK: - Sounds

	func playSoundForObject() {
		guard let soundURL = Bundle.main.url(forResource: currentObject.soundFilename, withExtension: nil) else {
			fatalError("Failed to find \(currentObject.soundFilename) in bundle")
		}
		do {
			soundPlayer = try AVAudioPlayer(contentsOf: soundURL)
			if gameType == .learn {
				soundPlayer?.numberOfLoops = currentObject.quantity * numberOfImagesToShow - 1
			} else {
				soundPlayer?.numberOfLoops = currentObject.quantity - 1
			}
			soundPlayer?.stop()
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
			// How to detect VoiceOver audio ducking on/off and change volume accordingly?
			soundPlayer?.volume = 0.1
			soundPlayer?.prepareToPlay()
			soundPlayer?.play()
		} catch {
			fatalError("Failed to play \(filename).caf: \(error)")
		}
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

	func playTimeUpSound() {
		let filename = "timeUp.caf"
		guard let soundURL = Bundle.main.url(forResource: filename, withExtension: nil) else {
			fatalError("Failed to find \(filename) in bundle")
		}
		do {
			soundPlayer?.stop()
			soundPlayer = try AVAudioPlayer(contentsOf: soundURL)
			soundPlayer?.volume = 1
			soundPlayer?.prepareToPlay()
			soundPlayer?.play()
		} catch {
			fatalError("Failed to play \(filename): \(error)")
		}
	}

	// MARK: - Answer Checking

	func getCorrectAnswer() -> String {
		return String(numberOfImagesToShow * currentObject.quantity)
	}

	func checkAnswer(_ answer: String) -> Bool {
		let correctAnswer = getCorrectAnswer()
		let correct = answer == correctAnswer
		playAnswerSound(correct)
		if correct {
			triesInGame += 1
			correctAnswersInGame += 1
		} else {
			triesInGame += 1
			numberOfIncorrectAnswers += 1
		}
		return correct
	}

	// MARK: - Game Timer

	func setupGameTimer(_ timerFireHandler: @escaping ((TimeInterval?) -> Void), timerEndHandler: @escaping (() -> Void)) {
		guard gameTimeLeft != nil else {
			timerFireHandler(nil)
			return }
		timerFireHandler(gameTimeLeft)
		gameTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [self] timer in
			gameTimeLeft! -= 1
			if gameTimeLeft! <= 0 {
				resetGameTimer()
				timerEndHandler()
			} else {
				timerFireHandler(gameTimeLeft)
			}
		})
	}

	func pauseGameTimer() {
		gameTimer?.invalidate()
	}

	func resetGameTimer() {
		gameTimer?.invalidate()
		gameTimer = nil
		gameTimeLeft = nil
	}

	// MARK: - Reset Game

	func resetGame() {
		speechSynthesizer.stopSpeaking(at: .immediate)
		soundPlayer?.stop()
		correctAnswersInGame = 0
		triesInGame = 0
		countingBy = nil
		gameType = nil
		resetGameTimer()
	}

}
