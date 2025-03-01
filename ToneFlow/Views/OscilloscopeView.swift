//
//  OscilloscopeView.swift
//  ToneFlow
//
//  Created by Wesley Grubbs on 2/28/25.
//

import SwiftUI
import AVFoundation

struct OscilloscopeView: View {
    let waveformType: DynamicAudioEngineManager.WaveformType
    let frequency: Float
    let amplitude: Float
    
    private let sampleCount = 100
    private let lineWidth: CGFloat = 2
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.black.opacity(0.8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white.opacity(0.5), lineWidth: 1)
                )
            
            WaveformShape(waveformType: waveformType, sampleCount: sampleCount, frequency: frequency, amplitude: amplitude)
                .stroke(Color.green, lineWidth: lineWidth)
                .padding(8)
        }
        .frame(width: 120, height: 80)
    }
}

struct WaveformShape: Shape {
    let waveformType: DynamicAudioEngineManager.WaveformType
    let sampleCount: Int
    let frequency: Float
    let amplitude: Float
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        let midY = height / 2
        
        // Scale amplitude to fit in the view
        let amplitudeScale = Float(height / 2) * min(amplitude, 1.0)
        
        // Starting point
        path.move(to: CGPoint(x: 0, y: midY))
        
        for i in 0..<sampleCount {
            let x = CGFloat(i) * width / CGFloat(sampleCount - 1)
            let normalizedX = Float(i) / Float(sampleCount - 1)
            let angle = 2.0 * Float.pi * normalizedX * frequency / 20.0 // Scale frequency for visualization
            
            var y: Float
            
            switch waveformType {
            case .sine:
                y = sin(angle)
            case .square:
                y = angle.truncatingRemainder(dividingBy: 2 * Float.pi) < Float.pi ? 1.0 : -1.0
            case .triangle:
                let normalized = angle.truncatingRemainder(dividingBy: 2 * Float.pi) / (2 * Float.pi)
                y = 2.0 * abs(2.0 * normalized - 1.0) - 1.0
            case .sawtooth:
                let normalized = angle.truncatingRemainder(dividingBy: 2 * Float.pi) / (2 * Float.pi)
                y = 2.0 * normalized - 1.0
            }
            
            let yPosition = CGFloat(midY - CGFloat(y * amplitudeScale))
            path.addLine(to: CGPoint(x: x, y: yPosition))
        }
        
        return path
    }
}

#Preview {
    OscilloscopeView(waveformType: .sine, frequency: 2.0, amplitude: 0.8)
        .frame(width: 120, height: 80)
        .background(Color.gray)
}
