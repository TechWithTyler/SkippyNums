//
//  ObjectImageView.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 8/15/23.
//  Copyright © 2023 SheftApps. All rights reserved.
//

import UIKit

// Displays a group of objects to count.
class ObjectImageView: UIImageView {

    // The timer used to highlight the image's background for a second when it's tapped/clicked or VoiceOver focuses on it in practice mode.
	var backgroundHighlightTimer: Timer? = nil

    // This method highlights the image's background.
	func highlightBackground() {
		backgroundColor = .gray.withAlphaComponent(0.3)
		backgroundHighlightTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { [self] timer in
			backgroundColor = nil
		})
	}

    // This method plays a chord or note, resets the VoiceOver announcement timer, and in practice mode, highlights the image's background, when VoiceOver focuses on it.
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
