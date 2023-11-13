//
//  ObjectImageView.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 8/15/23.
//

import UIKit

class ObjectImageView: UIImageView {

	var backgroundHighlightTimer: Timer? = nil

	func highlightBackground() {
		backgroundColor = .gray.withAlphaComponent(0.3)
		backgroundHighlightTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { [self] timer in
			backgroundColor = nil
		})
	}

	override func accessibilityElementDidBecomeFocused() {
		super.accessibilityElementDidBecomeFocused()
		GameBrain.shared.playChord()
		if GameBrain.shared.gameType == .practice {
			highlightBackground()
		}
		// Find the view controller that contains this image view
		var responder: UIResponder? = self
		while let next = responder?.next {
			responder = next
			if let viewController = responder as? GameViewController {
				// Reset the VoiceOver announcement timer
				viewController.announcementTimer?.invalidate()
				viewController.announcementTimer = nil
				break
			}
		}
	}

}
