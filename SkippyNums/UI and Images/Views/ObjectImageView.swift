//
//  ObjectImageView.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 8/15/23.
//  Copyright © 2023-2025 SheftApps. All rights reserved.
//

// MARK: - Imports

import UIKit

// Displays an image of a group of objects to count.
class ObjectImageView: UIImageView {

    // The timer used to highlight the image's background for a second when it's tapped/clicked or VoiceOver focuses on it in practice mode.
	var backgroundHighlightTimer: Timer? = nil

    // This method highlights the image's background.
	func highlightBackground() {
        // 1. Set the background color to gray, with less opacity if Increase Contrast is disabled or more opacity if it's enabled.
        let increaseContrast = UIAccessibility.isDarkerSystemColorsEnabled
        backgroundColor = .gray.withAlphaComponent(increaseContrast ? 0.7 : 0.3)
        // 2. Stop the backgroundHighlightTimer if it's already running.
        backgroundHighlightTimer?.invalidate()
        backgroundHighlightTimer = nil
        // 3. Start the backgroundHighlightTimer.
		backgroundHighlightTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { [self] timer in
			backgroundColor = nil
		})
	}

    // This method plays a chord or note, resets the VoiceOver announcement timer, and in practice mode, highlights the image's background, when VoiceOver focuses on it.
	override func accessibilityElementDidBecomeFocused() {
		super.accessibilityElementDidBecomeFocused()
        // 1. Play a chord or note.
		GameBrain.shared.playEarcon()
        // 2. Highlight the background if in practice mode.
		if GameBrain.shared.gameType == .practice {
			highlightBackground()
		}
		// 3. Find the view controller that contains this image view.
		var responder: UIResponder? = self
		while let next = responder?.next {
			responder = next
            // 4. Stop once responder is the GameViewController.
			if let viewController = responder as? GameViewController {
                // 5. Add the tag of this image view to the VoiceOver focused images set in the GameViewController.
                viewController.voiceOverFocusedImages.insert(tag)
                // 6. Reset the VoiceOver announcement timer.
				viewController.voiceOverAnnouncementTimer?.invalidate()
				viewController.voiceOverAnnouncementTimer = nil
                // 7. Reconfigure the accessibility for this image view after adding the tag to the VoiceOver focused images set.
                viewController.configureImageAccessibility(for: self)
				break
			}
		}
	}

}
