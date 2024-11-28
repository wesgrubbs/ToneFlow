//
//  ContentView.swift
//  ToneFlow
//
//  Created by Wesley Grubbs on 11/27/24.
//

import SwiftUI

struct ContentView: View {
    @State private var touchPoint: CGPoint

    // Initialize with a default center point
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
                
                // Intersection Point with Coordinate Label
                VStack(alignment: .leading, spacing: 5) {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 10, height: 10)
                        .offset(x: 44, y: 18) // Adjust offset for centering
                    
                    // Coordinate Label
                    Text("(\(Int(touchPoint.x)), \(Int(touchPoint.y)))")
                        .foregroundColor(Color.white)
                        .font(.title3)
                        .padding(4)
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(4)
                        .offset(x: 80, y: -60) // Adjust offset for placement
                }
                .position(touchPoint)
            }
            // Set initial touch point to center of the screen when the view appears
            .onAppear {
                touchPoint = CGPoint(
                    x: geometry.size.width / 2,
                    y: geometry.size.height / 2
                )
            }
            // Update touchPoint on tap or drag gestures
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged { value in
                        touchPoint = value.location
                    }
            )
        }
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    ContentView()
}
