//
//  DynanicAudioEngineManager.swift
//  ToneFlow
//
//  Created by Wesley Grubbs on 11/27/24.
//

import Foundation
import AVFoundation

class DynamicAudioEngineManager: ObservableObject {
    private var audioEngine: AVAudioEngine
    private var sourceNode: AVAudioSourceNode!
    private var frequency: Float = 440.0 // Default frequency of A4 note (440 Hz)
    private var sampleRate: Double = 44100.0 // Standard audio sample rate
    private var phase: Float = 0.0 // Tracks the phase of the waveform

    init() {
        audioEngine = AVAudioEngine()

        // Initialize the source node after everything else
        sourceNode = AVAudioSourceNode { [weak self] _, _, frameCount, audioBufferList -> OSStatus in
            guard let self = self else { return noErr }
            
            let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
            let phaseIncrement = (2.0 * Float.pi * self.frequency) / Float(self.sampleRate)

            for frame in 0..<Int(frameCount) {
                let sampleVal = sin(self.phase) // Generate sine wave
                self.phase += phaseIncrement
                if self.phase > 2.0 * Float.pi { self.phase -= 2.0 * Float.pi }

                // Write the sample to each channel in the buffer
                for buffer in ablPointer {
                    let buf = buffer.mData?.assumingMemoryBound(to: Float.self)
                    buf?[frame] = sampleVal
                }
            }

            return noErr
        }

        audioEngine.attach(sourceNode)
        audioEngine.connect(sourceNode, to: audioEngine.mainMixerNode, format: nil)
    }

    func startEngine(count: Int) {
        
        setFrequency(Float(count) + frequency)
        
        do {
            try audioEngine.start()
            print("Audio engine started \(count)")
        } catch {
            print("Error starting audio engine: \(error)")
        }
    }

    func stopEngine() {
        audioEngine.stop()
        print("Audio engine stopped")
    }

    func setFrequency(_ newFrequency: Float) {
        frequency = newFrequency
    }
}
