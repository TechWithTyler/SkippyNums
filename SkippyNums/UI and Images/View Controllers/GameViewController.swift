//
//  GameViewController.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 2/13/23.
//  Copyright © 2023-2024 SheftApps. All rights reserved.
//

import UIKit
import AVFoundation
import SheftAppsStylishUI

class GameViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {

    // MARK: - @IBOutlets - Buttons

    @IBOutlet weak var choice1Button: SAIAccessibleButton?

    @IBOutlet weak var choice2Button: SAIAccessibleButton?

    @IBOutlet weak var choice3Button: SAIAccessibleButton?

    @IBOutlet weak var choice4Button: SAIAccessibleButton?

    @IBOutlet weak var newGameButton: SAIAccessibleButton?

    // MARK: - @IBOutlets - Labels

    @IBOutlet weak var questionLabel: UILabel?

    @IBOutlet weak var scoreLabel: UILabel?

    @IBOutlet weak var secondsLeftLabel: UILabel?

    // MARK: - @IBOutlets - Other

    @IBOutlet weak var secondsLeftBar: UIProgressView?

    @IBOutlet weak var objectCollectionView: UICollectionView?

    // MARK: - Properties - Floats

    private let choiceButtonTextSize: CGFloat = 50

    // MARK: - Properties - Objects

    var gameBrain = GameBrain.shared

    // MARK: - Properties - Inactivity VoiceOver Announcement Timer

    var voiceOverAnnouncementTimer: Timer? = nil

    // MARK: - Properties - System Theme

    var systemTheme: UIUserInterfaceStyle {
        return traitCollection.userInterfaceStyle
    }

    // MARK: - View Setup/Update

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // 1. Hide the system-provided back button--a more visually-accessible "end game" button is used instead.
        navigationItem.hidesBackButton = true
        // 2. Set up the objectCollectionView's delegate and data source.
        setupObjectCollectionView()
        // 3. Set up the labels and seconds left bar.
        setupLabels()
        setupSecondsLeftBarTrackColor()
        // 4. Set up the gradient layer.
        setupGradient()
        // 5. Display a question to the player.
        newQuestion()
    }

    override func viewDidAppear(_ animated: Bool) {
        setupGameTimer()
        super.viewDidAppear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        gameBrain.resetGameTimer()
    }

    func setupLabels() {
        secondsLeftLabel?.text = "Loading…"
        scoreLabel?.isAccessibilityElement = true
    }

    func setupGradient() {
        // 1. Create the gradient layer.
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = systemTheme == .dark ? gradientColorsDark : gradientColorsLight
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
        // 2. Add the gradient layer to the view.
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    func setupSecondsLeftBarTrackColor() {
        let shouldFillTrack = UIAccessibility.isDarkerSystemColorsEnabled
        secondsLeftBar?.trackTintColor = shouldFillTrack ? .lightGray.withAlphaComponent(0.8) : .clear
    }

    func updateBackgroundColors() {
        // Update gradient colors based on device's dark/light mode
        if let gradientLayer = view.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.colors = systemTheme == .dark ? gradientColorsDark : gradientColorsLight
        }
    }

    func updateGradientFrame() {
        if let gradientLayer = view.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = view.bounds
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        // 1. Update the gradient colors when the device's dark/light mode changes.
        updateBackgroundColors()
        // 2. Show or hide the seconds left bar's track color when the Increase Contrast accessibility setting changes.
        setupSecondsLeftBarTrackColor()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Update frame of gradient layer when window size changes
        updateGradientFrame()
    }

    // MARK: - Game Timer - Setup

    func setupGameTimer() {
        // 1. Set up the gameTimer.
        gameBrain.setupGameTimer { [self] gameTimeLeft in
            // 2. Update the display when the timer fires if playing a timed game, or just once if playing an untimed or practice game.
            updateGameTimeDisplay(for: gameTimeLeft)
        } timerEndHandler: { [self] in
            // 3. If playing a timed game, switch to the "time's up!" screen and play a buzzer sound when time runs out.
            gameTimerEnded()
        }
    }

    // MARK: - Game Timer - Update

    func updateGameTimeDisplay(for gameTimeLeft: TimeInterval?) {
        // The gameTimer's timerFireHandler block (and this method which it calls) is still used for untimed/practice games--the block is called immediately and no timer is started.
        // 1. Get gameTimeLeft and gameBrain.gameLength as non-Optional constants if playing a timed game. If playing a practice or untimed game, skip to step 6.
        if let gameTimeLeft = gameTimeLeft, let gameLength = gameBrain.gameLength {
            // 2. Choose "second" or "seconds" based on whether the game time left is 1 second.
            let secondsSingularOrPlural = gameTimeLeft == 1 ? "second" : "seconds"
            // 3. Display the seconds left.
            let secondsLeftDisplay = "\(Int(gameTimeLeft)) \(secondsSingularOrPlural) left"
            secondsLeftLabel?.text = secondsLeftDisplay
            // 4. Divide the game time left by the game length to create the progress value and show it in the secondsLeftBar.
            let progress = (gameTimeLeft / gameLength)
            secondsLeftBar?.accessibilityValue = secondsLeftDisplay
            secondsLeftBar?.setProgress(Float(progress), animated: true)
            // 5. If time is 10 seconds or less, set the secondsLeftBar's color to red. Otherwise, set it to green.
            switch gameTimeLeft {
            case 0...10:
                secondsLeftBar?.progressTintColor = .systemRed
            default:
                secondsLeftBar?.progressTintColor = .systemGreen
            }
            secondsLeftBar?.isHidden = false
        } else {
            // 6. For an untimed or practice game, display the respective mode instead of a timer, and hide the secondsLeftBar.
            secondsLeftLabel?.text = gameBrain.gameType == .play ? "Untimed" : "Practice"
            secondsLeftBar?.isHidden = true
        }
    }

    // MARK: - Game Timer - End

    func gameTimerEnded() {
        // 1. Show the "time's up!" screen.
        performSegue(withIdentifier: "TimeUp", sender: self)
        // 2. Play a buzzer sound.
        gameBrain.playTimeUpSound()
    }

    // MARK: - Score Update

    func updateScoreDisplay() {
        scoreLabel?.text = gameBrain.scoreText
    }

    // MARK: - New Question

    func newQuestion() {
        // 1. Ask GameBrain for a new question.
        gameBrain.newQuestion()
        // 2. Get the question text and display it in the questionLabel.
        questionLabel?.text = gameBrain.getQuestionText()
        // 3. Configure the accessibility text for the objectCollectionView based on the question.
        objectCollectionView?.accessibilityLabel = gameBrain.backgroundAccessibilityText
        // 4. Set the choice buttons.
        setChoices()
        // 5. Set the initial score display.
        updateScoreDisplay()
        // 6. Reload the objectCollectionView with the images for the question.
        objectCollectionView?.reloadData()
        // 7. Reset the VoiceOver announcement timer.
        resetAnnouncementTimer()
    }

    func setChoices() {
        // 1. Convert the Int array of choices to String using map. Converting an array's elements from one type to another is a common use of map (when you don't want to throw out nil results) or compactMap (when you want to throw out nil results).
        let choices = gameBrain.getChoices().map { String($0) }
        // 2. Set each choice button's title to the corresponding item in the choices array, and set the font properties.
        choice1Button?.setTitle(choices[0], for: .normal)
        choice1Button?.usesMonospacedFont = true
        choice1Button?.textSize = choiceButtonTextSize
        choice2Button?.setTitle(choices[1], for: .normal)
        choice2Button?.usesMonospacedFont = true
        choice2Button?.textSize = choiceButtonTextSize
        choice3Button?.setTitle(choices[2], for: .normal)
        choice3Button?.usesMonospacedFont = true
        choice3Button?.textSize = choiceButtonTextSize
        choice4Button?.setTitle(choices[3], for: .normal)
        choice4Button?.usesMonospacedFont = true
        choice4Button?.textSize = choiceButtonTextSize
    }

    // MARK: - @IBActions

    @IBAction func answerSelected(_ sender: SAIAccessibleButton) {
        // 1. Check whether the selected answer is correct, incorrect, or the 3rd incorrect one in a row.
        guard let answer = sender.currentTitle else { return }
        let correct = gameBrain.checkAnswer(answer)
        let incorrectTooManyTimes = !correct && gameBrain.tooManyIncorrectAnswers
        // 2. Update the score display.
        updateScoreDisplay()
        // 3. Choose how to show the "correct/incorrect answer" sheet and decide whether to advance to a new question based on whether the answer is correct, incorrect, or the 3rd incorrect one in a row.
        if correct {
            // Correct answer, advance to new question
            performSegue(withIdentifier: "Correct", sender: sender)
            newQuestion()
        } else if incorrectTooManyTimes {
            // 3rd incorrect answer in a row, advance to new question
            performSegue(withIdentifier: "TooManyIncorrect", sender: sender)
            newQuestion()
        } else {
            // Incorrect answer, don't advance to new question
            performSegue(withIdentifier: "Incorrect", sender: sender)
        }
    }

    @IBAction func newGame(_ sender: Any) {
        resetGame()
    }

    // MARK: - Navigation - Storyboard Segue Preparation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 1. Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let answerCheckViewController = segue.destination as? AnswerCheckViewController {
            switch segue.identifier {
                // 2. If segue is used to present the AnswerCheckViewController (sheet), set the messageText and imageName of the AnswerCheckViewController based on which segue is used to present it. The segue to use to present it depends on whether the chosen answer is correct, incorrect, or the 3rd incorrect one in a row.
                // The "correct or incorrect" image's name is always "something.circle", so we only pass that something to AnswerCheckViewController which constructs the full image name.
            case "Incorrect":
                answerCheckViewController.messageText = "Incorrect! Try again!"
                answerCheckViewController.baseImageName = "x"
            case "TooManyIncorrect":
                answerCheckViewController.messageText = "Incorrect! The correct answer is \(gameBrain.getCorrectAnswer())."
                answerCheckViewController.baseImageName = "x"
            default:
                answerCheckViewController.messageText = "Correct!"
                answerCheckViewController.baseImageName = "checkmark"
            }
        } else if let timeUpViewController = segue.destination as? TimeUpViewController {
            // 3. If segue is used to present the TimeUpViewController (navigation), set the messageText of the TimeUpViewController.
            timeUpViewController.messageText = "Time's up! You answered \(gameBrain.scoreText)!"
        }
    }

    // MARK: - Navigation - Reset Game

    func resetGame() {
        gameBrain.resetGame()
        navigationController?.popToRootViewController(animated: true)
    }

    // MARK: - Inactivity VoiceOver Announcement

    func resetAnnouncementTimer() {
        // 1. Choose the VoiceOver announcement to use based on the device type.
#if targetEnvironment(macCatalyst)
        let message = "Starting from the top-left of the screen, move to each group of \(gameBrain.getDisplayNameForObject()) and count them, then if you'd like, activate to play the sound."
#else
        let message = "Starting from the top-left of the screen, drag your finger across each group of \(gameBrain.getDisplayNameForObject()) to count them, then if you'd like, split-tap (keep your finger on the screen and tap with a second) to play the sound."
#endif
        // 2. Setup the announcement timer to play the announcement after 15 seconds of inactivity as long as the "correct/incorrect answer" sheet isn't being displayed.
        let secondsToWait: TimeInterval = 15
        voiceOverAnnouncementTimer?.invalidate()
        voiceOverAnnouncementTimer = nil
        voiceOverAnnouncementTimer = Timer.scheduledTimer(withTimeInterval: secondsToWait, repeats: false) { [self] timer in
            guard presentedViewController == nil else { return }
            timer.invalidate()
            voiceOverAnnouncementTimer = nil
            speakVoiceOverMessage(message)
        }
    }

    func speakVoiceOverMessage(_ message: String) {
        UIAccessibility.post(notification: .announcement, argument: message)
    }

}

extension GameViewController {

    // MARK: - Object Collection View - Setup

    func setupObjectCollectionView() {
        // 1. Set the object collection view's delegate and data source.
        objectCollectionView?.dataSource = self
        objectCollectionView?.delegate = self
        // 2. Allow the user to interact with it.
        objectCollectionView?.isUserInteractionEnabled = true
        // 3. Don't show a background color as there's already a background gradient for the entire view.
        objectCollectionView?.backgroundColor = .clear
    }

    // MARK: - Object Collection View - Delegate and Data Source

    // Specifies the number of images to show.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let number = gameBrain.numberOfImagesToShow
        return number
    }

    // Shows an image in the collection view cell.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 1. Create a cell with identifier "ObjectCell".
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ObjectCell", for: indexPath)
        // 2. Create and configure the image view.
        let imageView = ObjectImageView(frame: cell.contentView.bounds)
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(named: gameBrain.currentObject.name)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.center = cell.contentView.center
        // 3. Create and configure the image view's tap gesture recognizer.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        tapGesture.numberOfTouchesRequired = 1
        tapGesture.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(tapGesture)
        // 4. Configure accessibility.
        imageView.isAccessibilityElement = true
        imageView.accessibilityTraits = [.startsMediaSession, .image]
        // The image view's tag is set to the respective skip count number, which will be announced in practice mode.
        imageView.tag = indexPath.item + 1
        imageView.accessibilityLabel = gameBrain.gameType == .play ? "\(gameBrain.imageAccessibilityText)" : "\(imageView.tag * gameBrain.currentObject.quantity)"
#if targetEnvironment(macCatalyst)
        let soundGesture = "Activate"
        let moveGesture = "Move"
#else
        let soundGesture = "Double-tap"
        let moveGesture = "Flick"
#endif
        if indexPath.item == 0 {
            // 5. Choose the accessibility hint based on which image has VoiceOver focus. If it's the first item, tell the player that they can activate the image to play the sound.
            imageView.accessibilityHint = "\(soundGesture) if you want to play the sound for this group of \(gameBrain.getDisplayNameForObject())."
        } else if indexPath.item == 4 && gameBrain.numberOfImagesToShow > 5 {
            // 6. If it's the 4th image (the last one in the 1st row), tell the player to move VoiceOver focus right so it focuses on the 5th image (the first one in the 2nd row).
            imageView.accessibilityHint = "Now \(moveGesture) right to move to the second row."
        } else if indexPath.item == gameBrain.numberOfImagesToShow - 1 {
            // 7. If it's the last image, tell the player that they've counted all the objects and to guide them to select an answer at the bottom.
            imageView.accessibilityHint = "That's all the \(gameBrain.getDisplayNameForObject()), how many \(gameBrain.getDisplayNameForObject()) altogether? Select from the choices at the bottom of the screen."
        }
        // 8. Disable keyboard focus for the cell.
        cell.focusEffect = nil
        // 9. Remove the previous image view (if any) from the cell before adding this one, otherwise multiple image views would overlap each other each time a new question is presented.
        cell.contentView.subviews.first?.removeFromSuperview()
        // 10. Add the image view to the cell's content view and return the cell.
        cell.contentView.addSubview(imageView)
        return cell
    }

    // Specifies spacing between the images in the collection view.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let sectionSpacing: CGFloat = 30
        return sectionSpacing
    }

    // Specifies sizing of the images in the collection view.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = objectInsets.left * 2
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / 6.2
        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    // MARK: - Object Collection View - Image Activation Handler

    @objc func imageTapped(_ sender: UIGestureRecognizer) {
        // 1. If in practice mode and VoiceOver is off, get the tapped image view and its tag (representing the skip count number) and use a dedicated speech synthesizer/highlight effect. VoiceOver is configured to handle this as part of creating the image view.
        if !UIAccessibility.isVoiceOverRunning && gameBrain.gameType == .practice {
            guard let image = sender.view as? ObjectImageView else { return }
            let skipCountNumber = image.tag * gameBrain.currentObject.quantity
            image.highlightBackground()
            gameBrain.speechSynthesizer.stopSpeaking(at: .immediate)
            gameBrain.speechSynthesizer.speak(AVSpeechUtterance(string: String(skipCountNumber)))
        }
        // 2. Play the object's sound (e.g., "moo, moo" for a group of 2 cows or "woof, woof, woof, woof, woof" for a group of 5 dogs).
        gameBrain.playSoundForObject()
    }

}
