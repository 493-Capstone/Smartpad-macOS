//
//  SearchingView.swift
//  Smartpad-macOS
//
//  Created by Arthur Chan on 2022-03-12.
//

import SwiftUI

// Reference for spinner:
// https://medium.com/swlh/swiftui-animations-loading-spinner-2e01a3d8e9c0
struct SearchingView: View {
    
    let rotationTime: Double = 2
    let fullRotation: Angle = .degrees(360)
    static let initialDegree: Angle = .degrees(270)
    
    @State var spinnerStart: CGFloat = 0.0
    @State var spinnerEndS1: CGFloat = 0.03
    @State var spinnerEndS2S3: CGFloat = 0.03
    @State var rotationDegreeS1 = initialDegree
    @State var rotationDegreeS2 = initialDegree + .degrees(120)
    @State var rotationDegreeS3 = initialDegree + .degrees(240)
    
    let animationTime: Double = 1.9
    
    var body: some View {
        ZStack{
            Circle().fill(Color.yellow).padding(50)
            Text("Searching...").foregroundColor(Color.black)
            SpinnerCircle(start: spinnerStart, end: spinnerEndS1, rotation: rotationDegreeS1, color: Color.red)
            SpinnerCircle(start: spinnerStart, end: spinnerEndS1, rotation: rotationDegreeS2, color: Color.green)
            SpinnerCircle(start: spinnerStart, end: spinnerEndS1, rotation: rotationDegreeS3, color: Color.blue)
        }.onAppear() {
            Timer.scheduledTimer(withTimeInterval: animationTime, repeats: true) { (mainTimer) in
                self.animateSpinner()
            }
        }
    }
    
    func animateSpinner(with timeInterval: Double, completion: @escaping (() -> Void)) {
        Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { _ in
            withAnimation(Animation.easeInOut(duration: rotationTime)) {
                completion()
            }
        }
    }

    func animateSpinner() {
        animateSpinner(with: rotationTime) { self.spinnerEndS1 = 1.0 }
        
        animateSpinner(with: (rotationTime * 2) - 0.025) {
                    self.rotationDegreeS1 += fullRotation
                    self.spinnerEndS2S3 = 0.8
                }

        animateSpinner(with: (rotationTime * 2)) {
            self.spinnerEndS1 = 0.03
            self.spinnerEndS2S3 = 0.03
        }

        animateSpinner(with: (rotationTime * 2) + 0.0525) { self.rotationDegreeS2 += fullRotation }

        animateSpinner(with: (rotationTime * 2) + 0.225) { self.rotationDegreeS3 += fullRotation }
    }
}

struct SearchingView_Previews: PreviewProvider {
    static var previews: some View {
        SearchingView()
    }
}

struct SpinnerCircle: View {
    var start: CGFloat
    var end: CGFloat
    var rotation: Angle
    var color: Color
    
    var body: some View {
        Circle()
            .trim(from: start, to: end)
            .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
            .fill(color)
            .rotationEffect(rotation)
    }
}
