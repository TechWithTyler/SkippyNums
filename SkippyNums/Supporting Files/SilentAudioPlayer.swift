//
//  SilentAudioPlayer.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 10/31/24.
//  Copyright © 2023-2024 SheftApps. All rights reserved.
//

import AVFoundation

// Plays a constant track of silence to prevent Bluetooth devices from switching away from the device playing SkippyNums audio.
class SilentAudioPlayer {

    // The audio engine, which manages the audio processing graph.
    var audioEngine: AVAudioEngine

    // The player node, responsible for audio playback in the engine.
    var playerNode: AVAudioPlayerNode

    // The audio format, specifying the sample rate and channel count.
    var audioFormat: AVAudioFormat

    init() {
        // 1. Initialize the audio engine components.
        self.audioEngine = AVAudioEngine()
        self.playerNode = AVAudioPlayerNode()
        self.audioFormat = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 2)!
        // 2. Setup the silence track by attaching and connecting nodes.
        setupSilenceTrack()
        // 3. Start playing the silence track.
        startSilenceTrack()
    }

    // Configures the silence track by attaching the player node and scheduling silent audio.
    func setupSilenceTrack() {
        audioEngine.attach(playerNode) // Attach the player node to the engine
        audioEngine.connect(playerNode, to: audioEngine.mainMixerNode, format: audioFormat) // Connect player to mixer
        scheduleSilentBuffer() // Schedule a silent audio buffer for looping playback
    }

    // Creates and schedules a silent audio buffer.
    func scheduleSilentBuffer() {
        let bufferDuration: TimeInterval = 1 // Duration for the silent buffer in seconds
        let frameCount = UInt32(bufferDuration * self.audioFormat.sampleRate) // Calculate frame count based on duration
        if let buffer = AVAudioPCMBuffer(pcmFormat: self.audioFormat, frameCapacity: frameCount) {
            buffer.frameLength = frameCount // Set the buffer frame length
            // Fill the buffer's channels with silence by setting data to zero
            memset(buffer.floatChannelData![0], 0, Int(buffer.frameCapacity) * MemoryLayout<Float>.size)
            memset(buffer.floatChannelData![1], 0, Int(buffer.frameCapacity) * MemoryLayout<Float>.size)
            // Schedule the silent buffer to play in a continuous loop
            playerNode.scheduleBuffer(buffer, at: nil, options: .loops, completionHandler: nil)
        }
    }

    // Starts the silence track by starting the audio engine and playing the player node.
    func startSilenceTrack() {
        do {
            try audioEngine.start() // Start the audio engine
            self.playerNode.play() // Begin playback of the player node
        } catch {
            print("Failed to start audio engine: \(error)") // Handle error if engine fails to start
        }
    }

    func stopSilenceTrack() {
        audioEngine.stop()
        playerNode.stop()
    }

}
