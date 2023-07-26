//
//  ContentView.swift
//  GesturePlay
//
//  Created by Martin Wiingaard on 30/10/2020.
//

import SwiftUI

struct CirclePlayView: View {
    
    let colors: [UIColor] = [
        .systemBlue,
        .systemGreen,
        .systemIndigo,
        .systemOrange,
        .systemPink,
        .systemPurple,
        .systemRed,
        .systemTeal,
        .systemYellow
    ]
    var all: Int { colors.count }
    
    @State private var offset = CGSize.zero
    
    
    var totalRotation: Double = 360
    var totalDelay: Double = 0.3
    
    func rotationAngle(_ number: Int) -> Angle {
        Angle(degrees: (totalRotation / Double(all)) * Double(number))
    }
    
    func delay(_ number: Int) -> Double {
        Double(number)/Double(all) * totalDelay
    }
    
    func delayAnimation(_ number: Int) -> Animation {
        Animation.easeOut.delay(delay(number))
    }
    
    func color(_ number: Int) -> Color {
        Color.init(colors[number])
    }
    
    var body: some View {
        let dragGesture = DragGesture()
            .onChanged { change in
                offset = change.translation
            }
            .onEnded { _ in
                withAnimation(Animation.default) {
                    self.offset = .zero
                }
            }
        
        ZStack {
            ForEach((0..<colors.count), id: \.self) { number in
                Circle()
                    .fill(color(number))
                    .frame(width: 64, height: 64)
                    .offset(offset.rotate(rotationAngle(number)))
                    .animation(delayAnimation(number))
                    .zIndex(Double(all-number))
            }
            .simultaneousGesture(dragGesture)
        }
    }
}

struct CircleContentView: View {
    @State private var rotation: Double = 0
    @State private var duration: Double = 0.3
        
    var body: some View {
        ZStack {
            CirclePlayView(totalRotation: rotation, totalDelay: duration)
            SettingsView {
                VStack {
                    HStack {
                        Text("Rotation")
                        Slider.init(value: $rotation, in: 0...360)
                    }
                    HStack {
                        Text("Duration")
                        Slider.init(value: $duration, in: 0.01...3)
                    }
                }
            }
        }
    }
}

struct CircleContentView_Previews: PreviewProvider {
    static var previews: some View {
        CircleContentView()
    }
}

extension CGSize {
    func rotate(_ angle: Angle) -> CGSize {
        let point = CGPoint(x: width, y: height)
        let radians = CGFloat(angle.radians)
        let rotation = CGAffineTransform(rotationAngle: radians)
        let rotated = point.applying(rotation)
        return CGSize(width: rotated.x, height: rotated.y)
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = 8
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
