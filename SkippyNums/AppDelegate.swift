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

    // MARK: - Properties - Silent Audio Player

    // An audio player that plays a silent track to keep the audio session active. This helps prevent Bluetooth audio streams from being considered "ended" (e.g. Bluetooth headphones connected to 2 devices switching away from the SkippyNums device and to the other connected device playing audio) when a sound stops.
    var silentAudioPlayer: SilentAudioPlayer?

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
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    // MARK: - UISceneSession Lifecycle - Discard

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
        stopAudio()
    }

    // MARK: - Game Audio - Initial Configuration

    func initializeGameAudio() {
        // 1. Configure the game's audio session.
        configureAudioSession()
        // 2. Configure the audio route change handlers, which will move the SilentAudioPlayer to a different available audio source (e.g. from device speakers to Bluetooth headphones and back).
        configureAudioRouteChangeHandlers()
        // 3. With everything configured, create the SilentAudioPlayer instance to keep the audio session active.
        silentAudioPlayer = SilentAudioPlayer()
    }

    // MARK: - Game Audio - Route Change Handler

    func configureAudioRouteChangeHandlers() {
        // 1. Get the audio session.
        let audioSession = AVAudioSession.sharedInstance()
        // 2. Define the number of milliseconds between stopping and reconfiguring the audio session after an audio route change. This short delay is necessary to allow the audio session to properly reset after the route change.
        let audioSessionResetTime: Int = 100 // milliseconds
        // 3. Add observers for the audio session interruption and route change notifications. For the interruption notification, stop the audio when an interruption begins and reconfigure the audio session when it ends. For the route change notification, stop the audio and reconfigure the audio session after the short delay.
        NotificationCenter.default.addObserver(forName: AVAudioSession.interruptionNotification, object: audioSession, queue: nil) { [self] notification in
            guard let userInfo = notification.userInfo, let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt, let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
                return
            }
            switch type {
                case .began:
                stopAudio()
                case .ended:
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) { [self] in
                    configureAudioSession()
                }
                @unknown default:
                    break
            }
        }
        NotificationCenter.default.addObserver(forName: AVAudioSession.routeChangeNotification, object: audioSession, queue: nil) { [self] notification in
            self.stopAudio()
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(audioSessionResetTime)) { [self] in
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

