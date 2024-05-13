//
//  LearnViewController.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 8/3/23.
//  Copyright © 2023-2024 SheftApps. All rights reserved.
//

import UIKit
import SheftAppsStylishUI

class LearnViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {

	@IBOutlet weak var questionLabel: UILabel?

	@IBOutlet weak var objectCollectionView: UICollectionView?

	@IBOutlet weak var newGameButton: SAIAccessibleButton?

	private let sectionInsets = UIEdgeInsets(
		top: 50.0,
		left: 20.0,
		bottom: 50.0,
		right: 20.0)

	var gameBrain = GameBrain.shared

	var announcementTimer: Timer? = nil

	// MARK: - Setup

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
        // 1. Set up the objectCollectionView and image tap gesture.
		setupObjectCollectionView()
        // 2. Hide the system-provided back button--a more visually-accessible "end game" button is used instead.
        navigationItem.hidesBackButton = true
        // 3. Set up the gradient layer.
        setupGradient()
        // 4. Show an example.
		newQuestion()
	}

    func setupGradient() {
        // 1. Create the gradient layer.
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = traitCollection.userInterfaceStyle == .dark ? gradientColorsDark : gradientColorsLight
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
        // 2. Add the gradient layer to the view.
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
	}

	@objc func imageTapped(_ sender: Any) {
		if let player = gameBrain.soundPlayer, player.isPlaying {
			player.stop()
		} else {
			gameBrain.playSoundForObject()
		}
	}

	@objc func updateBackgroundColors() {
		// Update gradient colors based on device's dark/light mode
		if let gradientLayer = view.layer.sublayers?.first as? CAGradientLayer {
			gradientLayer.colors = traitCollection.userInterfaceStyle == .dark ? gradientColorsDark : gradientColorsLight
		}
	}

	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		// Update gradient colors when device's dark/light mode changes
		updateBackgroundColors()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		if let gradientLayer = view.layer.sublayers?.first as? CAGradientLayer {
			gradientLayer.frame = view.bounds
		}
	}

	func resetGame() {
		gameBrain.resetGame()
		navigationController?.popToRootViewController(animated: true)
	}

	func newQuestion() {
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

	@IBAction func newExample(_ sender: Any) {
		newQuestion()
	}
	
	@IBAction func newGame(_ sender: Any) {
		resetGame()
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
		let paddingSpace = sectionInsets.left * 2
		let availableWidth = view.frame.width - paddingSpace
		let widthPerItem = availableWidth / 6.2
		return CGSize(width: widthPerItem, height: widthPerItem)
	}


}
