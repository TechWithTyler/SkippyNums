//
//  SceneDelegate.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 2/13/23.
//  Copyright © 2023-2025 SheftApps. All rights reserved.
//

import UIKit
import AVFoundation

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: - Properties - Window

	var window: UIWindow?
    
    var gameBrain = GameBrain.shared
    
    // MARK: - Scene Lifecycle - Connect

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		// Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
		// If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
		// This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
		guard let windowScene = (scene as? UIWindowScene) else { return }
		#if targetEnvironment(macCatalyst)
		windowScene.titlebar?.titleVisibility = .hidden
        windowScene.sizeRestrictions?.minimumSize = CGSize(width: 1024, height: 768)
		#endif
        resumeGame()
	}
    
    // MARK: - Scene Lifecycle - Disconnect

	func sceneDidDisconnect(_ scene: UIScene) {
		// Called as the scene is being released by the system.
		// This occurs shortly after the scene enters the background, or when its session is discarded.
		// Release any resources associated with this scene that can be re-created the next time the scene connects.
		// The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
	}
    
    // MARK: - Scene Lifecycle - Activation

	func sceneDidBecomeActive(_ scene: UIScene) {
		// Called when the scene has moved from an inactive state to an active state.
		// Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        resumeGame()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        pauseGame()
    }

    // MARK: - Scene Lifecycle - Background/Foreground

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
	}

    func pauseGame() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.stopAudio()
        gameBrain.pauseGameTimer()
    }

    func resumeGame() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.configureAudioSession()
        if let navigationController = window?.rootViewController as? UINavigationController, let gameViewController = navigationController.topViewController as? GameViewController {
            if gameBrain.gameLength != nil {
                gameViewController.setupGameTimer(toResume: true)
            }
        }
    }

}

