//
//  LearnViewController.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 8/3/23.
//  Copyright © 2023-2025 SheftApps. All rights reserved.
//

import UIKit
import SheftAppsStylishUI

class LearnViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {

    // MARK: - @IBOutlets

	@IBOutlet weak var questionLabel: UILabel?

	@IBOutlet weak var objectCollectionView: UICollectionView?

	@IBOutlet weak var newGameButton: SAIAccessibleButton?

    // MARK: - Properties - Objects

	var gameBrain = GameBrain.shared

    // MARK: - Properties - Inactivity VoiceOver Announcement Timer

	var announcementTimer: Timer? = nil

    // MARK: - Properties - System Theme

    var systemTheme: UIUserInterfaceStyle {
        return traitCollection.userInterfaceStyle
    }

	// MARK: - View Setup/Update

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
        // 1. Set up the objectCollectionView and image tap gesture.
		setupObjectCollectionView()
        // 2. Hide the system-provided back button--a more visually-accessible "end game" button is used instead.
        navigationItem.hidesBackButton = true
        // 3. Set up the gradient layer.
        setupGradient()
        // 4. Update the gradient colors when the device's dark/light mode changes.
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { [self] (self: Self, previousTraitCollection: UITraitCollection) in
            updateBackgroundColors()
        }
        // 5. Allow the question label to be tapped/clicked to speak the question.
        questionLabel?.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(questionTapped(_:)))
        tapGesture.numberOfTouchesRequired = 1
        tapGesture.numberOfTapsRequired = 1
        questionLabel?.addGestureRecognizer(tapGesture)
        // 6. Show an example.
		newExample(self)
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Update frame of gradient layer when window size changes
        updateGradientFrame()
    }

    // MARK: - Reset Game

	func resetGame() {
		gameBrain.resetGame()
		navigationController?.popToRootViewController(animated: true)
	}

    // MARK: - @IBActions

	@IBAction func newExample(_ sender: Any) {
        gameBrain.newQuestion()
        questionLabel?.text = gameBrain.getQuestionText()
        objectCollectionView?.accessibilityLabel = gameBrain.backgroundAccessibilityText
#if targetEnvironment(macCatalyst)
        let soundGesture = "Activate"
#else
        let soundGesture = "Double-tap"
#endif
        objectCollectionView?.accessibilityHint = "\(soundGesture) to hear the \(gameBrain.getDisplayNameForObject())."
        objectCollectionView?.reloadData()
	}

	@IBAction func newGame(_ sender: Any) {
		resetGame()
	}

    // MARK: - Speak Question

    // This method speaks the question text when it's tapped/clicked.
    @objc func questionTapped(_ sender: UIGestureRecognizer) {
        guard !UIAccessibility.isVoiceOverRunning else { return }
        let questionText = (questionLabel?.text)!
        let utterance = AVSpeechUtterance(string: questionText)
        gameBrain.speechSynthesizer.stopSpeaking(at: .immediate)
        gameBrain.speechSynthesizer.speak(utterance)
    }

}

extension LearnViewController {

    // MARK: - Object Collection View - Setup

    func setupObjectCollectionView() {
        objectCollectionView?.dataSource = self
        objectCollectionView?.delegate = self
        objectCollectionView?.isUserInteractionEnabled = true
        objectCollectionView?.isAccessibilityElement = true
        objectCollectionView?.accessibilityTraits = [.startsMediaSession]
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        tapGesture.numberOfTouchesRequired = 1
        tapGesture.numberOfTapsRequired = 1
        objectCollectionView?.addGestureRecognizer(tapGesture)
        objectCollectionView?.backgroundColor = .clear
    }

	// MARK: - Object Collection View - Delegate and Data Source

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		let number = gameBrain.numberOfImagesToShow
		return number
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ObjectCellLearn", for: indexPath)
		// 1. Create and configure the image view
		let imageView = ObjectImageView(frame: cell.contentView.bounds)
		imageView.image = UIImage(named: gameBrain.currentObject.name)
		imageView.contentMode = .scaleAspectFit
		imageView.clipsToBounds = true
		imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		imageView.center = cell.contentView.center
		cell.focusEffect = nil
		// 2. Add the image view to the cell's content view
		cell.contentView.subviews.first?.removeFromSuperview()
		cell.contentView.addSubview(imageView)
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 30
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let paddingSpace = objectInsets.left * 2
		let availableWidth = view.frame.width - paddingSpace
		let widthPerItem = availableWidth / 6.2
		return CGSize(width: widthPerItem, height: widthPerItem)
	}

    // MARK: - Object Collection View - Image Activation Handler

    @objc func imageTapped(_ sender: Any) {
        if let player = gameBrain.soundPlayer, player.isPlaying {
            player.stop()
        } else {
            gameBrain.playSoundForObject()
        }
    }

}
