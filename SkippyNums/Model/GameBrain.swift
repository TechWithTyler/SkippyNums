//
//  GameBrain.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 2/14/23.
//  Copyright © 2023-2024 SheftApps. All rights reserved.
//

import UIKit
import AVFoundation

// This is the main model object (i.e., the brain) of this game.
class GameBrain {

	// MARK: - Game Type Enum

    // Types of gameplay.
	enum GameType {
		
        // Player is asked to choose the correct answer, can be 1min, 2min, or untimed.
		case play

        // Player is asked to choose the correct answer, untimed, announces number in the sequence when tapped/clicked/VoiceOver focused.
		case practice

        // Player is given all information to learn how to skip-count.
		case learn

	}

	// MARK: - Properties - Shared GameBrain

    // A shared instance of GameBrain that can be used by any view controller.
	static var shared: GameBrain = GameBrain()

	// MARK: - Properties - Objects to Count

    // The set of objects to count.
	static var objectsToCount: [any CountableObject] = [
		// Comment out objects if they're not ready to commit or ship.
        // For objects only available in the twos, fives, or tens game, the quantity isn't specified when initializing the object. Objects that are available in more than one game are initialized with a quantity, which determines which image to use.
        // Twos
        Cow(), // Introduced in version 2023.11
        Elephant(), // Introduced in version 2023.11
        Car(), // Introduced in version 2023.11
        // Fives
        Airplane(), // Introduced in version 2023.11
        // Tens
        Bear(), // Introduced in version 2024.3
        // Mix (twos/fives/tens)
        Bird(quantity: 2), // Introduced in version 2023.11
        Monkey(quantity: 2), // Introduced in version 2023.11
        Cat(quantity: 2), // Introduced in version 2024.3
        Dog(quantity: 2), // Introduced in version 2024.3
        Bird(quantity: 5), // Introduced in version 2023.11
        Monkey(quantity: 5), // Introduced in version 2023.11
        Cat(quantity: 5), // Introduced in version 2024.3
        Dog(quantity: 5), // Introduced in version 2024.3
        Bird(quantity: 10), // Introduced in version 2023.11
        Monkey(quantity: 10), // Introduced in version 2023.11
        Cat(quantity: 10), // Introduced in version 2024.3
        Dog(quantity: 10), // Introduced in version 2024.3
        // Mix (twos and fives)
        Robot(quantity: 2), // Introduced in version 2023.11
        Robot(quantity: 5) // Introduced in version 2023.11
	]

	// MARK: - Properties - Speech Synthesizer

    // The speech synthesizer which announces an object's quantity when tapping/clicking it in Practice mode with VoiceOver off.
	var speechSynthesizer = AVSpeechSynthesizer()

	// MARK: - Properties - Settings Data

    // The SettingsData object for the GameBrain.
	var settingsData = SettingsData()

	// MARK: - Properties - Game Type

    // The type of game (play, practice, or learn), or nil if on the main menu.
	var gameType: GameType? = nil

	// MARK: - Properties - Current Object

    // The current question's object (the object currently being counted).
    var currentObject: any CountableObject = GameBrain.objectsToCount.randomElement()!

	// MARK: - Properties - Integers

    // The number of images to show (any number between 2 and 10). Each image contains 2, 5, or 10 (depending on the quantity) instances of the object being counted.
	var numberOfImagesToShow: Int = 2

    // The number of correct answers in the current game.
	var correctAnswersInGame: Int = 0

    // The number of tries in the current game.
	var triesInGame: Int = 0

    // The number of incorrect answers for the current question.
	var numberOfIncorrectAnswers = 0
	
    // The number the player is counting by, or nil if playing the Mix game. This determines which images to show.
	var countingBy: Int?

	// MARK: - Properties - Time Intervals

    // The number of seconds left in the current game, or nil if playing an untimed or practice game or in learn mode.
	var gameTimeLeft: TimeInterval? = nil

	// MARK: - Properties - Game Timer

    // The game timer.
	var gameTimer: Timer? = nil

	// MARK: - Properties - Learn Mode Numbers

    // An array of numbers which learn mode randomly picks from when showing example questions.
	let learnModeNumbers: [Int] = [2, 5, 10]

	// MARK: - Properties - Sound Player

    // The game's sound player.
	var soundPlayer: AVAudioPlayer? = nil

	// MARK: - Properties - Booleans

    // Whether the player is starting a new game (true) or new round in the current game (false) when the timer goes off.
	var isNewRoundInCurrentGame: Bool = false

    // Whether the player got too many incorrect answers in a row.
	var tooManyIncorrect: Bool {
		return numberOfIncorrectAnswers == 3
	}

	// MARK: - Properties - Strings

    // The accessibility text for the current question's images (e.g. "2 cows" or "5 birds").
	var imageAccessibilityText: String {
		return "\(currentObject.quantity) \(getDisplayNameForObject())"
	}

    // The accessibility text for the background.
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

	// MARK: - Learn Mode

    // This method starts learn mode with the given object.
    func newLearnModeExample(withObject object: CountableObject.Type) {
        currentObject = object.init(quantity: countingBy ?? learnModeNumbers.randomElement()!)
	}

	// MARK: - New Question

    // This method presents a new question.
	func newQuestion() {
		let maxNumber = settingsData.tenFrame ? 10 : 5
		numberOfImagesToShow = Int.random(in: 2...maxNumber)
		numberOfIncorrectAnswers = 0
		if gameType == .learn {
            // type(of:) allows you to get the dynamic type (e.g. Dog) from the given value's static type (e.g. currentObject which is anything that conforms to CountableObject).
            newLearnModeExample(withObject: type(of: currentObject))
		} else {
			let previousObjectName = currentObject.name
			let previousNumberOfImages = numberOfImagesToShow
			if countingBy == nil {
				currentObject = GameBrain.objectsToCount.randomElement()!
			} else {
				currentObject = GameBrain.objectsToCount.filter({$0.quantity == countingBy}).randomElement()!
			}
            let isSameQuestionContent = currentObject.name == previousObjectName && numberOfImagesToShow == previousNumberOfImages
			if isSameQuestionContent {
				// If the next question/learn mode example is identical to the previous one, try again until a different question is shown.
				newQuestion()
			}
		}
	}

	// MARK: - Get Data to Display

    // This method gets the display name for the current object, removing the leading number if any. For example, if the current object's name is "2monkeys", use that full name to look up the image to use, but drop the leading 2 so the displayed/announced name is "monkeys". For objects that only have one quantity (e.g. cows only come in twos), the name has no leading number so nothing will be dropped from it (e.g. "cows").
	func getDisplayNameForObject() -> String {
		return currentObject.name.filter { $0.isLetter }
	}

    // This method gets the current object's quantity and display name and returns a question created from that data.
	func getQuestionText() -> String {
        // 1. Convert the quantity number to words.
		var quantityWord: String {
			switch currentObject.quantity {
				case 5: return "fives"
				case 10: return "tens"
				default: return "twos"
			}
		}
        // 2. If in learn mode, use the background's accessibility text as the question text.
        if gameType == .learn {
            return backgroundAccessibilityText
        } else {
            // 3. If in play or practice mode, construct and return the question text.
            let text = "Count the \(getDisplayNameForObject()) by \(quantityWord)."
            return text
        }
	}

    // This method creates 5 choices based on the number of images to show and the current object's quantity. 4 of these choices are displayed to the player, one of which is correct. The non-displayed choice is used only to assist with randomizing the available choices so the correct one isn't always in an obvious place.
	func getChoices() -> [String] {
        // 1. Create choices.
        // Below correct answer
		let incorrectChoice1A = numberOfImagesToShow * currentObject.quantity - (currentObject.quantity * 2)
        let incorrectChoice1B = numberOfImagesToShow * currentObject.quantity + (currentObject.quantity * 3)
		let incorrectChoice2 = numberOfImagesToShow * currentObject.quantity - currentObject.quantity
		// Correct answer
		let correctChoice = numberOfImagesToShow * currentObject.quantity
		// Above correct answer
		let incorrectChoice3 = numberOfImagesToShow * currentObject.quantity + currentObject.quantity
		let incorrectChoice4 = numberOfImagesToShow * currentObject.quantity + (currentObject.quantity * 2)
        // 2. Shuffle the incorrect answers. If incorrect choice 1A resolves to 0, use incorrect choice 1B instead, which is 1 multiple higher than incorrect choice 4.
        let shuffledIncorrectChoices = [String(incorrectChoice1A == 0 ? incorrectChoice1B : incorrectChoice1A), String(incorrectChoice2), String(incorrectChoice3), String(incorrectChoice4)].shuffled()
        // 3. Drop the last incorrect choice and append the correct choice.
        var finalChoices = Array(shuffledIncorrectChoices.dropLast())
        finalChoices.append(String(correctChoice))
        // 4. Re-shuffle the choices and return them.
        finalChoices.shuffle()
		return finalChoices
	}

	// MARK: - Sounds
    
    // This method starts the game's audio.
    func startAudio() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            fatalError("Couldn't start audio: \(error)")
        }
    }
    
    // This method stops the game's audio.
    func stopAudio() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient)
            try AVAudioSession.sharedInstance().setActive(false)
        } catch {
            fatalError("Couldn't stop audio: \(error)")
        }
    }

    // This method plays the current object's sound when it's tapped/clicked.
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

    // This function plays a chord or note as a VoiceOver earcon when it focuses on an image.
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

    // This method plays a "correct answer" or "incorrect answer" sound when choosing an answer.
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

    // This method plays a buzzer when the game timer finishes.
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

    // This method calculates the correct answer based on the number of images to show and the current object's quantity, and returns the result as a String.
	func getCorrectAnswer() -> String {
		return String(numberOfImagesToShow * currentObject.quantity)
	}

    // This method compares answer with the correct answer, plays a sound, and increments the tries in the current game by 1. If it's correct, the number of correct answers in the current game increases by 1. If it's incorrect, the number of incorrect answers for the current question increases by 1. The resulting Bool is used to determine how the answer screen should display.
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

    // This method winds up the game timer, calling the timer fire handler every second, and calling the timer end handler when the timer ends.
	func setupGameTimer(_ timerFireHandler: @escaping ((TimeInterval?) -> Void), timerEndHandler: @escaping (() -> Void)) {
        // 1. If gameTimeLeft is nil, call the timer fire handler with a nil value and don't start the timer.
		guard gameTimeLeft != nil else {
			timerFireHandler(nil)
			return }
        // 2. If gameTimeLeft is specified, call the timer fire handler with the initial value and start the gameTimer.
		timerFireHandler(gameTimeLeft)
		gameTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [self] timer in
            // 3. Decrease gameTimeLeft by 1 every second.
			gameTimeLeft! -= 1
            // 4. If gameTimeLeft is (or falls below) 0 seconds, reset the gameTimer and call the timer end handler.
			if gameTimeLeft! <= 0 {
				resetGameTimer()
				timerEndHandler()
			} else {
                // 5. Otherwise, call the timer fire handler with the new value.
				timerFireHandler(gameTimeLeft)
			}
		})
	}

    // This method pauses the game timer.
	func pauseGameTimer() {
		gameTimer?.invalidate()
	}

    // This method stops the game timer and resets the properties back to default.
	func resetGameTimer() {
        // 1. Stop the gameTimer.
		gameTimer?.invalidate()
		gameTimer = nil
        // 2. Reset gameTimeLeft to nil.
		gameTimeLeft = nil
	}

	// MARK: - Reset Game

    // This method stops all audio, stops the game timer, and resets the properties back to default. If choosing to play another round in the current game, stats and the game type aren't reset.
	func resetGame() {
        // 1. Stop all sounds and non-VoiceOver speech.
		speechSynthesizer.stopSpeaking(at: .immediate)
        soundPlayer?.stop()
        // 2. Reset the gameTimer.
        resetGameTimer()
        // 3. Reset the game stats to default.
        correctAnswersInGame = 0
        triesInGame = 0
        // 4. Reset the gameplay properties to nil. gameTimeLeft was already reset to nil when resetting the gameTimer.
        countingBy = nil
        gameType = nil
	}

}
