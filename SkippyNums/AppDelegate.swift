//
//  AppDelegate.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 2/13/23.
//  Copyright © 2023-2025 SheftApps. All rights reserved.
//

import UIKit
import AVFoundation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var silentAudioPlayer: SilentAudioPlayer?

    // MARK: - Application Lifecycle - Setup

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
        // 1. Configure the game's audio.
        configureAudioSession()
        configureAudioRouteChangeHandlers()
        silentAudioPlayer = SilentAudioPlayer()
		return true
	}

	// MARK: - UISceneSession Lifecycle - Configuration

	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		// Called when a new scene session is being created.
		// Use this method to select a configuration to create the new scene with.
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}

    // MARK: - UISceneSession Lifecycle - Discard

	func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
		// Called when the user discards a scene session.
		// If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
		// Use this method to release any resources that were specific to the discarded scenes, as they will not return.
	}

    // MARK: - Audio Session Configuration

    func configureAudioRouteChangeHandlers() {
        let audioSession = AVAudioSession.sharedInstance()
        NotificationCenter.default.addObserver(forName: AVAudioSession.interruptionNotification, object: audioSession, queue: nil) { notification in
            guard let userInfo = notification.userInfo, let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt, let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
                return
            }
            switch type {
                case .began:
                self.stopAudio()
                case .ended:
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                    self.configureAudioSession()
                }
                @unknown default:
                    break
            }
        }
        NotificationCenter.default.addObserver(forName: AVAudioSession.routeChangeNotification, object: audioSession, queue: nil) { notification in
            self.stopAudio()
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                self.configureAudioSession()
            }
        }
    }

    func stopAudio() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            silentAudioPlayer?.stopSilenceTrack()
            try audioSession.setCategory(.ambient, mode: .default, options: [])
            try audioSession.setActive(false)
        } catch {
            print("Failed to stop audio session: \(error)")
        }
    }

    func configureAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try audioSession.setActive(true)
            silentAudioPlayer?.startSilenceTrack()
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }

}

