//
//  AppDelegate.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 2/13/23.
//  Copyright © 2023-2024 SheftApps. All rights reserved.
//

import UIKit
import AVFoundation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Application Lifecycle - Setup

    var silentAudioPlayer: SilentAudioPlayer?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
        configureAudioSession()
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

    func configureAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .default, options: [])
            try audioSession.setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }

}

class SilentAudioPlayer {
    private var audioEngine: AVAudioEngine
    private var playerNode: AVAudioPlayerNode
    private var audioFormat: AVAudioFormat

    init() {
        self.audioEngine = AVAudioEngine()
        self.playerNode = AVAudioPlayerNode()
        self.audioFormat = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 2)!

        self.audioEngine.attach(self.playerNode)
        self.audioEngine.connect(self.playerNode, to: self.audioEngine.mainMixerNode, format: self.audioFormat)

        self.scheduleSilentBuffer()

        do {
            try self.audioEngine.start()
            self.playerNode.play()
        } catch {
            print("Failed to start audio engine: \(error)")
        }
    }

    private func scheduleSilentBuffer() {
        let bufferDuration: TimeInterval = 1 // seconds
        let frameCount = UInt32(bufferDuration * self.audioFormat.sampleRate)

        if let buffer = AVAudioPCMBuffer(pcmFormat: self.audioFormat, frameCapacity: frameCount) {
            buffer.frameLength = frameCount
            memset(buffer.floatChannelData![0], 0, Int(buffer.frameCapacity) * MemoryLayout<Float>.size)
            memset(buffer.floatChannelData![1], 0, Int(buffer.frameCapacity) * MemoryLayout<Float>.size)

            self.playerNode.scheduleBuffer(buffer, at: nil, options: .loops, completionHandler: nil)
        }
    }
}


