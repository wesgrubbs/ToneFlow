//
//  ContentView.swift
//  ToneFlow
//
//  Created by Wesley Grubbs on 11/27/24.
//

import SwiftUI
import Combine

struct ContentView: View {
    @ObservedObject var audioEngineManager = DynamicAudioEngineManager()
    @State private var xNorm: Float = 0
    @State private var yNorm: Float = 0
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    @State private var touchPoint: CGPoint
    @State private var currentFrequency: Float = 440.0
    private let oscilloscopeUpdateTimer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    init() {
        _touchPoint = State(initialValue: CGPoint(x: 0, y: 0))
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Horizontal Line
                Path { path in
                    path.move(to: CGPoint(x: 0, y: touchPoint.y))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: touchPoint.y))
                }
                .stroke(Color.white, lineWidth: 1)
                
                // Vertical Line
                Path { path in
                    path.move(to: CGPoint(x: touchPoint.x, y: 0))
                    path.addLine(to: CGPoint(x: touchPoint.x, y: geometry.size.height))
                }
                .stroke(Color.white, lineWidth: 1)
                
                // Intersection Point
                Circle()
                    .fill(Color.white)
                    .frame(width: 20, height: 20)
                    .position(touchPoint)
                
                // Mini Oscilloscope View at bottom right
                OscilloscopeView(
                    waveformType: audioEngineManager.waveformType,
                    frequency: currentFrequency,
                    amplitude: yNorm
                )
                .position(
                    x: geometry.size.width - 70,
                    y: geometry.size.height - 130
                )
                
                // Parameters display in bottom right
                VStack(alignment: .leading, spacing: 4) {
                    Text("WAVEFORM")
                        .font(.caption2)
                        .foregroundColor(.gray)
                    
                    Text(audioEngineManager.waveformType.rawValue)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("FREQUENCY")
                        .font(.caption2)
                        .foregroundColor(.gray)
                        .padding(.top, 4)
                    
                    Text("\(Int(currentFrequency)) Hz")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("VOLUME")
                        .font(.caption2)
                        .foregroundColor(.gray)
                        .padding(.top, 4)
                    
                    Text("\(Int(yNorm * 100))%")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.black.opacity(0.8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                )
                .position(
                    x: 60,
                    y: geometry.size.height - 170
                )
            }
            .onAppear {
                touchPoint = CGPoint(
                    x: geometry.size.width / 2,
                    y: geometry.size.height / 2
                )
                // Initialize normalized values on appear
                xNorm = Float(touchPoint.x / screenWidth)
                yNorm = Float(touchPoint.y / screenHeight)
                calculateFrequency()
                
                // Start oscilloscope refresh timer
                _ = oscilloscopeUpdateTimer
            }
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged { value in
                        touchPoint = value.location
                        xNorm = Float(touchPoint.x / screenWidth)
                        yNorm = Float(touchPoint.y / screenHeight)
                        calculateFrequency()
                        audioEngineManager.startEngine(xVal: xNorm, yVal: yNorm)
                    }
                    .onEnded { _ in
                        audioEngineManager.stopEngine()
                    }
            )
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Picker("Waveform", selection: $audioEngineManager.waveformType) {
                        ForEach(DynamicAudioEngineManager.WaveformType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
        }
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }
    
    private func calculateFrequency() {
        // Calculate frequency based on x position (same calculation as in AudioEngineManager)
        let minFrequency: Float = 10.0
        let maxFrequency: Float = 2000.0
        currentFrequency = xNorm * (maxFrequency - minFrequency) + minFrequency
    }
}

#Preview {
    ContentView()
}
