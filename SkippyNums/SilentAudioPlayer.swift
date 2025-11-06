//
//  SilentAudioPlayer.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 10/31/24.
//  Copyright © 2023-2025 SheftApps. All rights reserved.
//

// MARK: - Imports

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
        // Initialize the audio engine components.
        self.audioEngine = AVAudioEngine()
        self.playerNode = AVAudioPlayerNode()
        self.audioFormat = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 2)!
    }

    // Configures the silence track by attaching the player node and scheduling silent audio.
    func setupSilenceTrack() {
        // 1. Attach the player node to the engine.
        audioEngine.attach(playerNode)
        // 2. Connect the player to the mixer.
        audioEngine.connect(playerNode, to: audioEngine.mainMixerNode, format: audioFormat)
        audioEngine.isAutoShutdownEnabled = false
        // 3. Schedule a silent audio buffer for looping playback.
        scheduleSilentBuffer()
    }

    // Creates and schedules a silent audio buffer.
    func scheduleSilentBuffer() {
        // 1. Calculate the total number of frames required for the buffer.
        let bufferDuration: TimeInterval = 1 // 1-second buffer duration
        let frameCount = UInt32(bufferDuration * self.audioFormat.sampleRate)
        // 2. Create an audio buffer with the specified format and frame capacity.
        if let buffer = AVAudioPCMBuffer(pcmFormat: self.audioFormat, frameCapacity: frameCount) {
            buffer.frameLength = frameCount // Set the actual frame length
            let volume: Float = 0 // Set volume to 0 to create silence
            let leftChannel = buffer.floatChannelData?[0]
            let rightChannel = buffer.floatChannelData?[1]
            // 3. Fill the buffer with silent audio samples for both channels
            for frame in 0..<Int(frameCount) {
                leftChannel?[frame] = (Float.random(in: -1.0...1.0)) * volume // Left channel
                rightChannel?[frame] = (Float.random(in: -1.0...1.0)) * volume // Right channel
            }
            // 4. Schedule the buffer to play in a loop
            playerNode.scheduleBuffer(buffer, at: nil, options: .loops, completionHandler: nil)
        }
    }

    // Starts the silence track by starting the audio engine and playing the player node.
    func startSilenceTrack() {
        // 1. Setup the silence track by attaching and connecting nodes.
        setupSilenceTrack()
        // 2. Try to play the silent audio track.
        do {
            audioEngine.prepare()
            try audioEngine.start() // Start the audio engine
            self.playerNode.play() // Begin playback of the player node
        } catch {
            print("Failed to start audio engine: \(error)") // Handle error if engine fails to start
        }
    }

    func stopSilenceTrack() {
        playerNode.stop()
        audioEngine.stop()
        audioEngine.reset()
    }

}
