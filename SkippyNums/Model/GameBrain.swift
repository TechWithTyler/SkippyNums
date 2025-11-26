//
//  GameBrain.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 2/14/23.
//  Copyright © 2023-2025 SheftApps. All rights reserved.
//

// MARK: - Imports

import UIKit
import AVFoundation

// This is the main model object (i.e., the brain) of this game.
class GameBrain {

    // MARK: - Game Type Enum

    // Types of gameplay.
    enum GameType {

        // Player is asked to choose the correct answer, can be 1min, 2min, or untimed.
        case play

        // Player is asked to choose the correct answer, untimed, announces number in the sequence/highlights image when tapped/clicked/VoiceOver focused.
        case practice

        // Player is given all information to learn how to skip-count, tapping any image plays the sound as many times as there are the given object.
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
        // Cherries were used in the very early days of development (February-March 2023) while we were implementing the core functionality of the game. We switched to cows as the first shipping object as there's no obvious sound associated with cherries.
        Cow(), // Present since the initial release (2023.11)
        Elephant(), // Present since the initial release (2023.11)
        Car(), // Present since the initial release (2023.11)
        // Fives
        Airplane(), // Present since the initial release (2023.11)
        // Tens
        Bear(), // Introduced in version 2024.3
        // Mix (twos/fives/tens)
        // Objects in this group are eligible for learn mode.
        Bird(quantity: 2), // Present since the initial release (2023.11)
        Monkey(quantity: 2), // Present since the initial release (2023.11)
        Cat(quantity: 2), // Introduced in version 2024.3
        Dog(quantity: 2), // Introduced in version 2024.3
        Bird(quantity: 5), // Present since the initial release (2023.11)
        Monkey(quantity: 5), // Present since the initial release (2023.11)
        Cat(quantity: 5), // Introduced in version 2024.3
        Dog(quantity: 5), // Introduced in version 2024.3
        Bird(quantity: 10), // Present since the initial release (2023.11)
        Monkey(quantity: 10), // Present since the initial release (2023.11)
        Cat(quantity: 10), // Introduced in version 2024.3
        Dog(quantity: 10), // Introduced in version 2024.3
        // Mix (twos and fives)
        Robot(quantity: 2), // Present since the initial release (2023.11)
        Robot(quantity: 5) // Present since the initial release (2023.11)
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

    // The number of incorrect answers for the current question, which is used to reveal the correct answer and skip to a new question if the player gets 3 incorrect answers in a row.
    var numberOfIncorrectAnswersForQuestion: Int = 0

    // The number the player is counting by, or nil if playing the Mix game. This determines which images to show.
    var countingBy: Int?

    // MARK: - Properties - Time Intervals

    // The number of seconds left in the current game, or nil if playing an untimed or practice game or in learn mode.
    // TimeInterval is a type alias for Double, and is often used when a value is a number of seconds.
    var gameTimeLeft: TimeInterval? = nil

    // The number of seconds to start the gameTimer with, or nil if playing an untimed or practice game or in learn mode.
    var gameLength: TimeInterval? = nil

    // MARK: - Properties - Game Timer

    // The game timer.
    var gameTimer: Timer? = nil

    // MARK: - Properties - Learn Mode Numbers

    // An array of numbers which mixed learn mode randomly picks from when showing examples.
    let learnModeNumbers: [Int] = [2, 5, 10]

    // MARK: - Properties - Sound Player

    // The game's sound player.
    var soundPlayer: AVAudioPlayer? = nil

    // MARK: - Properties - Booleans

    // Whether the player is starting a new game (true) or a new round in the current game (false) when the timer goes off. A new round in the current game keeps the game stats (number of tries/correct answers) the same, hides the Untimed option from the game length page, and brings the player back to the "choose your game" page, whereas a new game resets all properties for the current game and returns to the main menu.
    var isNewRoundInCurrentGame: Bool = false

    // Whether the player got too many incorrect answers in a row. The game reveals the correct answer and skips to a new question in this case.
    var tooManyIncorrectAnswers: Bool {
        return numberOfIncorrectAnswersForQuestion == 3
    }

    // MARK: - Properties - Strings

    // The number of tries in the current game with "try" or "tries" based on whether triesInGame is 1.
    var triesSingularOrPlural: String {
        return "\(triesInGame) " + (triesInGame == 1 ? "try" : "tries")
    }

    // The text to display in the score label during gameplay or on the time up screen (e.g. "3 of 5 tries correct".
    var scoreText: String {
        return "\(correctAnswersInGame) of \(triesSingularOrPlural) correct"
    }

    // The accessibility text for the current question's images (e.g. "2 cows" or "5 birds").
    var imageAccessibilityText: String {
        return "\(currentObject.quantity) \(getDisplayNameForObject())"
    }

    // The accessibility text for the background.
    var backgroundAccessibilityText: String {
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
            let normalString = "\(numberOfImagesToShow) groups of \(currentObject.quantity) \(getDisplayNameForObject())"
            return normalString
        }
    }

    // MARK: - Learn Mode

    // This method starts learn mode with the given object.
    func startLearnMode(withObject object: CountableObject.Type) {
        // 1. Get a new learn mode example with object.
        newLearnModeExample(withObject: object)
        // 2. Play the object's sound once.
        playSoundForObject(forLearnModeObjectSelection: true)
    }

    // This method presents a new example in learn mode.
    func newLearnModeExample(withObject object: CountableObject.Type) {
        // 1. If the object's sound is playing for object selection, stop it.
        let playingSoundForObjectSelection = soundPlayer?.numberOfLoops == 0
        if !playingSoundForObjectSelection {
            soundPlayer?.stop()
        }
        // 2. Set currentObject to a new instance of object with the selected quantity.
        currentObject = object.init(quantity: countingBy ?? learnModeNumbers.randomElement()!)
    }

    // MARK: - New Question

    // This method presents a new question in play or practice mode, or a new learn mode example in learn mode.
    func newQuestion() {
        // 1. Determine the maximum number of images to show (5 or 10) based on whether "maximum number of groups" is set to 5 or 10. The minimum number of images to display is 2.
        let maxNumber = settingsData.tenFrame ? 10 : 5
        numberOfImagesToShow = Int.random(in: 2...maxNumber)
        // 2. If in learn mode, present a new example.
        if gameType == .learn {
            // type(of:) allows you to get the dynamic type (e.g. Dog) from the given value's static type (e.g. currentObject which is anything that conforms to CountableObject).
            let object = type(of: currentObject)
            newLearnModeExample(withObject: object)
        } else {
            // 3. If in play or practice mode, set the current object to a new object.
            let previousObjectName = currentObject.name
            let previousNumberOfImages = numberOfImagesToShow
            if countingBy == nil {
                currentObject = GameBrain.objectsToCount.randomElement()!
            } else {
                currentObject = GameBrain.objectsToCount.filter({$0.quantity == countingBy}).randomElement()!
            }
            // 4. Reset the incorrect answer count to 0.
            numberOfIncorrectAnswersForQuestion = 0
            // 5. If the next question is identical to the previous one (i.e., the new question's object and number of images to show are the same), try again until a different question (i.e., either the object or number of images to show are different) is shown.
            let isSameQuestionContent = currentObject.name == previousObjectName && numberOfImagesToShow == previousNumberOfImages
            if isSameQuestionContent {
                newQuestion()
            }
        }
        // 6. Stop speech.
        speechSynthesizer.stopSpeaking(at: .immediate)
    }

    // MARK: - Get Data to Display

    // This method gets the display name for the current object, removing the leading number if any. For example, if the current object's name is "2monkeys", use that full name to look up the image to use, but drop the leading 2 so the displayed/announced name is "monkeys". For objects that only have one quantity (e.g. cows only come in twos), the name has no leading number so nothing will be dropped from it (e.g. "cows").
    func getDisplayNameForObject() -> String {
        let imageName = currentObject.name
        let displayName = imageName.filter { $0.isLetter }
        return displayName
    }

    // This method gets the current object's quantity and display name and returns a question created from that data.
    func getQuestionText() -> String {
        // 1. If in learn mode, use the background's accessibility text as the question text.
        if gameType == .learn {
            return backgroundAccessibilityText
        } else {
            // 2. If in play or practice mode, construct and return the question text.
            // Convert the quantity number to words.
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
    }

    // This method creates 5 choices whose Int values are based on the number of images to show times the current object's quantity. 4 of these choices are displayed to the player, one of which is correct. The non-displayed 5th choice is used only to assist with randomizing and shuffling the available choices so the correct one isn't always in an obvious place and so the number sequence isn't obvious.
    func getChoices() -> [Int] {
        // 1. Get the correct answer, which is used to calculate the values of each choice.
        let correctAnswer = Int(getCorrectAnswer())!
        // 2. Create choices. In the examples below, numberOfImagesToShow is 3 and currentObject.quantity is 2 (correctAnswer is numberOfImagesToShow times currentObject.quantity).
        // Below correct answer
        // Example: 3 times 2 minus (2 times 2) = 2
        let incorrectChoice1A = correctAnswer - (currentObject.quantity * 2)
        // Example: 3 times 2 plus (2 times 3) = 12 (not used in this example since incorrectChoice1A isn't 0)
        let incorrectChoice1B = correctAnswer + (currentObject.quantity * 3)
        // Example: 3 times 2 minus 2 = 4
        let incorrectChoice2 = correctAnswer - currentObject.quantity
        // Correct answer
        // Example: 3 times 2 = 6
        let correctChoice = correctAnswer
        // Above correct answer
        // Example: 3 times 2 plus 2 = 8
        let incorrectChoice3 = correctAnswer + currentObject.quantity
        // Example: 3 times 2 plus (2 times 2) = 10
        let incorrectChoice4 = correctAnswer + (currentObject.quantity * 2)
        // 3. Shuffle the 4 incorrect choices. If incorrect choice 1A is 0, use incorrect choice 1B instead, which is 1 multiple higher than incorrect choice 4.
        let shuffledIncorrectChoices = [incorrectChoice1A == 0 ? incorrectChoice1B : incorrectChoice1A, incorrectChoice2, incorrectChoice3, incorrectChoice4].shuffled()
        // 4. Drop the last incorrect choice and append the correct one. These are the final 4 choices that are displayed to the player.
        var finalChoices = Array(shuffledIncorrectChoices.dropLast())
        finalChoices.append(correctChoice)
        // 5. Re-shuffle the final set of 4 choices (the choices offered to the player) and return them.
        finalChoices.shuffle()
        return finalChoices
    }

    // MARK: - Sound

    // This method plays the current object's sound when it's tapped/clicked, or when selecting the object to count in learn mode. When tapping/clicking an image in play or practice mode, the sound is played as many times as the object appears in the image. When tapping/clicking an image in learn mode, the sound is played as many times as the object appears on the screen. When selecting the object to count in learn mode, the sound is played only once.
    func playSoundForObject(forLearnModeObjectSelection: Bool = false) {
        // 1. Make sure the current object's sound exists in the app bundle.
        guard let soundURL = Bundle.main.url(forResource: currentObject.soundFilename, withExtension: nil) else {
            fatalError("Failed to find \(currentObject.soundFilename) in bundle")
        }
        do {
            // 2. Try to load the sound into the player.
            soundPlayer = try AVAudioPlayer(contentsOf: soundURL)
            // 3. Set the number of loops for the sound. If selecting the object to count in learn mode, play it only once (no loops). If in learn mode, play the sound as many times as the object appears on the screen. For example, if there are 4 groups of 5 dogs, play the dog sound 20 times (play it once, then loop it 19 times). If in play or practice mode, play the sound as many times as the object appears in the tapped/clicked image. For example, for a group of 5 cats, play the cat sound 5 times (play it once, then loop it 4 times).
            if forLearnModeObjectSelection {
                soundPlayer?.numberOfLoops = 0
            } else if gameType == .learn {
                let numberOfObjectsOnScreen = currentObject.quantity * numberOfImagesToShow
                soundPlayer?.numberOfLoops = numberOfObjectsOnScreen - 1
            } else {
                soundPlayer?.numberOfLoops = currentObject.quantity - 1
            }
            // 4. Stop any playing sound.
            soundPlayer?.stop()
            // 5. Enable rate adjustment and set the rate to the current object's specified rate. Objects whose sounds are more than half a second long are sped up.
            soundPlayer?.enableRate = true
            soundPlayer?.rate = currentObject.soundRate
            // 6. Prepare and play the sound.
            soundPlayer?.volume = 1
            soundPlayer?.prepareToPlay()
            soundPlayer?.play()
        } catch {
            // 7. If an error occurs, throw a fatal error.
            fatalError("Failed to play \(currentObject.soundFilename): \(error)")
        }
    }

    // This method plays a chord or note as a VoiceOver earcon when it focuses on an image.
    func playEarcon() {
        // 1. Select the appropriate earcon based on the current object's quantity.
        var filename: String {
            switch currentObject.quantity {
            case 10: return "tenChord"
            case 5: return "fiveChord"
            default: return "twoNote"
            }
        }
        // 2. Make sure the sound exists in the app bundle.
        guard let soundURL = Bundle.main.url(forResource: filename, withExtension: "caf") else {
            fatalError("Failed to find \(filename).caf in bundle")
        }
        do {
            // 3. Stop any playing sound.
            soundPlayer?.stop()
            // 4. Try to load the sound into the player.
            soundPlayer = try AVAudioPlayer(contentsOf: soundURL)
            // 5. Set the volume to 10% (0.1).
            soundPlayer?.volume = 0.1
            // 6. Prepare and play the sound.
            soundPlayer?.prepareToPlay()
            soundPlayer?.play()
        } catch {
            // 7. If an error occurs, throw a fatal error.
            fatalError("Failed to play \(filename).caf: \(error)")
        }
    }

    // This method plays a "correct answer" or "incorrect answer" sound when choosing an answer.
    func playAnswerSound(_ correct: Bool) {
        // 1. Choose the appropriate sound based on whether the player's answer is correct.
        let filename = correct ? "correct" : "incorrect"
        // 2. Make sure the sound exists in the app bundle.
        guard let soundURL = Bundle.main.url(forResource: filename, withExtension: "caf") else {
            fatalError("Failed to find \(filename).caf in bundle")
        }
        do {
            // 3. Stop any playing sound.
            soundPlayer?.stop()
            // 4. Try to load the sound into the player.
            soundPlayer = try AVAudioPlayer(contentsOf: soundURL)
            if !correct {
                // 5. For the "incorrect answer" sound, slow it down to half-speed since the sound isn't very long.
                soundPlayer?.enableRate = true
                soundPlayer?.rate = 0.5
            }
            // 6. Prepare and play the sound.
            soundPlayer?.volume = 1
            soundPlayer?.prepareToPlay()
            soundPlayer?.play()
        } catch {
            // 7. If an error occurs, throw a fatal error.
            fatalError("Failed to play \(filename).caf: \(error)")
        }
    }

    // This method plays a buzzer when the game timer finishes.
    func playTimeUpSound() {
        // 1. Make sure the sound exists in the app bundle.
        let filename = "timeUp"
        guard let soundURL = Bundle.main.url(forResource: filename, withExtension: "caf") else {
            fatalError("Failed to find \(filename).caf in bundle")
        }
        do {
            // 2. Stop any playing sound.
            soundPlayer?.stop()
            // 3. Try to load the sound into the player.
            soundPlayer = try AVAudioPlayer(contentsOf: soundURL)
            // 4. Prepare and play the sound.
            soundPlayer?.volume = 1
            soundPlayer?.prepareToPlay()
            soundPlayer?.play()
        } catch {
            // 5. If an error occurs, throw a fatal error.
            fatalError("Failed to play \(filename).caf: \(error)")
        }
    }

    // MARK: - Answer Checking

    // This method calculates the correct answer based on the number of images to show and the current object's quantity, and returns the result as a String.
    func getCorrectAnswer() -> String {
        // Example: If numberOfImagesToShow is 3 and currentObject.quantity is 2, the correct answer is 6.
        let correctAnswer = numberOfImagesToShow * currentObject.quantity
        return String(correctAnswer)
    }

    // This method compares answer with the correct answer, plays a sound, and increments the tries in the current game by 1. If it's correct, the number of correct answers in the current game increases by 1. If it's incorrect, the number of incorrect answers for the current question increases by 1 (a value of 3 means reveal the correct answer and skip to a new question). The resulting Bool is used to determine how the answer screen should display.
    func checkAnswer(_ answer: String) -> Bool {
        let correctAnswer = getCorrectAnswer()
        let correct = answer == correctAnswer
        playAnswerSound(correct)
        if correct {
            triesInGame += 1
            correctAnswersInGame += 1
        } else {
            triesInGame += 1
            numberOfIncorrectAnswersForQuestion += 1
        }
        return correct
    }

    // MARK: - Game Timer

    // This method winds up the game timer, calling the timer fire handler every second (or only once if playing an untimed or practice game to trigger a stat update), and calling the timer end handler when the timer ends.
    func setupGameTimer(toResume: Bool = false, timerFireHandler: @escaping ((TimeInterval?) -> Void), timerEndHandler: @escaping (() -> Void)) {
        // 1. If gameLength is nil, call the timer fire handler with a nil value and don't start the timer.
        guard gameLength != nil else {
            timerFireHandler(nil)
            return
        }
        // 2. If gameLength is specified, call the timer fire handler with the initial value and start the gameTimer.
        if !toResume {
            gameTimeLeft = gameLength
            timerFireHandler(gameTimeLeft)
        }
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] timer in
            // 3. Decrease gameTimeLeft by 1 every second.
            gameTimeLeft! -= 1
            // 4. If gameTimeLeft is (or falls below) 0 seconds, reset the gameTimer and call the timer end handler.
            if gameTimeLeft! <= 0 {
                resetGameTimer()
                playTimeUpSound()
                timerEndHandler()
            } else {
                // 5. Otherwise, call the timer fire handler with the new value.
                timerFireHandler(gameTimeLeft)
            }
        }
    }

    // This method pauses the game timer when the game becomes inactive (e.g. by moving to the background).
    func pauseGameTimer() {
        gameTimer?.invalidate()
        gameTimer = nil
    }

    // This method stops the game timer and resets the properties back to default.
    func resetGameTimer() {
        // 1. Stop the gameTimer.
        gameTimer?.invalidate()
        gameTimer = nil
        // 2. Reset gameTimeLeft to nil.
        gameTimeLeft = nil
        gameLength = nil
    }

    // MARK: - Reset Game

    // This method stops all audio, stops the game timer, and resets the properties back to default. If choosing to play another round in the current game, the game isn't reset and this method won't be called.
    func resetGame() {
        // 1. Stop all sounds and non-VoiceOver speech.
        speechSynthesizer.stopSpeaking(at: .immediate)
        soundPlayer?.stop()
        // 2. Reset the gameTimer.
        resetGameTimer()
        // 3. Reset the game stats to default.
        correctAnswersInGame = 0
        triesInGame = 0
        isNewRoundInCurrentGame = false
        // 4. Reset the gameplay properties to nil. gameTimeLeft was already reset to nil when resetting the gameTimer.
        countingBy = nil
        gameType = nil
    }

}
