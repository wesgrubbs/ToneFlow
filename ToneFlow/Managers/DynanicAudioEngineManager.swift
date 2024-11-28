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
    private var originalFrequency: Float = 440.0 // Default frequency
    private var sampleRate: Double = 20100.0
    private var phase: Float = 0.0
    
    // Define frequency limits for the audio range (human hearing range)
    private let minFrequency: Float = 10.0 // Minimum frequency (human hearing range)
    private let maxFrequency: Float = 2000.0 // Maximum frequency (human hearing range)


    @Published var waveformType: WaveformType = .sine

    enum WaveformType: String, CaseIterable {
        case sine = "Sine"
        case square = "Square"
        case triangle = "Triangle"
        case sawtooth = "Sawtooth"
    }

    init() {
        audioEngine = AVAudioEngine()
        sourceNode = AVAudioSourceNode { [weak self] _, _, frameCount, audioBufferList -> OSStatus in
            guard let self = self else { return noErr }
            
            let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
            let phaseIncrement = (2.0 * Float.pi * self.originalFrequency) / Float(self.sampleRate)

            for frame in 0..<Int(frameCount) {
                let sampleVal: Float
                switch self.waveformType {
                case .sine:
                    sampleVal = sin(self.phase)
                case .square:
                    sampleVal = self.phase < Float.pi ? 1.0 : -1.0
                case .triangle:
                    sampleVal = 2.0 * abs(2.0 * (self.phase / (2.0 * Float.pi)) - 1.0) - 1.0
                case .sawtooth:
                    sampleVal = 2.0 * (self.phase / (2.0 * Float.pi)) - 1.0
                }

                self.phase += phaseIncrement
                if self.phase > 2.0 * Float.pi { self.phase -= 2.0 * Float.pi }

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

    func startEngine(xVal: Float, yVal: Float) {
        let playFreq = xVal * (maxFrequency - minFrequency) + minFrequency
        setFrequency(playFreq)
        setAmplitude(yVal)

        do {
            try audioEngine.start()
            print("Audio engine started with waveform \(waveformType.rawValue), frequency \(playFreq)")
        } catch {
            print("Error starting audio engine: \(error)")
        }
    }

    func stopEngine() {
        audioEngine.stop()
        print("Audio engine stopped")
    }

    func setFrequency(_ newFrequency: Float) {
        originalFrequency = newFrequency
    }

    func setAmplitude(_ amplitude: Float) {
        let volume = max(0.0, min(1.0, amplitude))
        audioEngine.mainMixerNode.outputVolume = volume
    }
}
