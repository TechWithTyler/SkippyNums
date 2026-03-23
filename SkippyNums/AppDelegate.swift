//
//  AppDelegate.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 2/13/23.
//  Copyright © 2023-2026 SheftApps. All rights reserved.
//

// MARK: - Imports

import UIKit
import AVFoundation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties - Silent Audio Player

    // An audio player that plays a silent track to keep the audio session active. This helps prevent Bluetooth audio streams from being considered "ended" (e.g. Bluetooth headphones connected to 2 devices switching away from the SkippyNums device and to the other connected device playing audio) when a sound stops.
    var silentAudioPlayer: SilentAudioPlayer?

    // MARK: - Properties - Integers

    // The number of milliseconds between stopping and reconfiguring the audio session after an audio route change. This short delay is necessary to allow the audio session to properly reset after the route change.
    let audioSessionResetTimeInMilliseconds: Int = 100

    // MARK: - Application Lifecycle - Setup

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Configure the game's audio.
        initializeGameAudio()
        return true
    }

    // MARK: - Menu Bar Configuration

    override func buildMenu(with builder: any UIMenuBuilder) {
        super.buildMenu(with: builder)
        removeUnusedMenus(with: builder)
    }

    // This method removes unused menus from the menu bar.
    func removeUnusedMenus(with builder: any UIMenuBuilder) {
        builder.remove(menu: .document)
        builder.remove(menu: .edit)
        builder.remove(menu: .format)
        builder.remove(menu: .toolbar)
        builder.remove(menu: .sidebar)
        builder.remove(menu: .help)
    }

    // MARK: - UISceneSession Lifecycle - Configuration

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        let configurationName = "Default Configuration"
        let configuration = UISceneConfiguration(name: configurationName, sessionRole: connectingSceneSession.role)
        return configuration
    }

    // MARK: - UISceneSession Lifecycle - Discard

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
        stopAudio()
    }

    // MARK: - Game Audio - Initial Configuration

    // This method initializes the game's audio.
    func initializeGameAudio() {
        // 1. Configure the game's audio session.
        configureAudioSession()
        // 2. Configure the audio route change handlers, which will move the SilentAudioPlayer to a different available audio source (e.g. from device speakers to Bluetooth headphones and back).
        configureAudioRouteChangeHandlers()
        // 3. With everything configured, create the SilentAudioPlayer instance to keep the audio session active.
        silentAudioPlayer = SilentAudioPlayer()
    }

    // MARK: - Game Audio - Route Change Handler

    // This method sets up the game to listen for notifications when the device's audio source (route) changes and when audio is interrupted.
    func configureAudioRouteChangeHandlers() {
        // 1. Get the audio session.
        let audioSession = AVAudioSession.sharedInstance()
        // 2. Add observers for the audio session interruption and route change notifications. For the interruption notification, stop the audio when an interruption begins and reconfigure the audio session when it ends. For the route change notification, stop the audio and reconfigure the audio session after the short delay.
        NotificationCenter.default.addObserver(forName: AVAudioSession.interruptionNotification, object: audioSession, queue: nil) { [self] notification in
            handleAudioInterruption(notification: notification)
        }
        NotificationCenter.default.addObserver(forName: AVAudioSession.routeChangeNotification, object: audioSession, queue: nil) { [self] notification in
            handleAudioRouteChange(notification: notification)
        }
    }

    // This method handles changes to audio session interruption status.
    func handleAudioInterruption(notification: Notification) {
        // 1. Make sure we can get the notification's user info and that we can get the audio session interruption type from that user info.
        guard let userInfo = notification.userInfo, let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt, let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
            return
        }
        // 2. Stop audio or reconfigure the audio session based on whether an interruption started or stopped. Do nothing for unknown interruption types.
        switch type {
            case .began:
            stopAudio()
            case .ended:
            DispatchQueue.main
                .asyncAfter(deadline: .now() + .milliseconds(audioSessionResetTimeInMilliseconds)) { [self] in
                configureAudioSession()
            }
            default:
                break
        }
    }

    // This method handles device audio source (route) changes.
    func handleAudioRouteChange(notification: Notification) {
        // 1. Stop audio.
        stopAudio()
        // 2. After 100ms, reconfigure the audio session.
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(audioSessionResetTimeInMilliseconds)) { [self] in
            self.configureAudioSession()
        }
    }

    // This method stops the game's silent audio player and deactivates the audio session.
    func stopAudio() {
        // 1. Get the audio session.
        let audioSession = AVAudioSession.sharedInstance()
        do {
            // 2. Stop the silence track.
            silentAudioPlayer?.stopSilenceTrack()
            // 3. Try to set the audio session category, mode, and options back to default and stop it.
            try audioSession.setCategory(.ambient, mode: .default, options: [])
            try audioSession.setActive(false)
        } catch {
            // 4. If that fails, throw a fatal error.
            fatalError("Failed to stop audio session: \(error)")
        }
    }

    // This method configures the game's audio session and starts the silence track.
    func configureAudioSession() {
        // 1. Get the audio session.
        let audioSession = AVAudioSession.sharedInstance()
        do {
            // 2. Try to set the audio session category, mode, and options, and start it.
            try audioSession.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try audioSession.setActive(true)
            // 3. If successful, start the silence track.
            silentAudioPlayer?.startSilenceTrack()
        } catch {
            // 4. Otherwise, throw a fatal error.
            fatalError("Failed to set up audio session: \(error)")
        }
    }

}

