//
//  TimerPlay.swift
//  GesturePlay
//
//  Created by Martin Wiingaard on 22/11/2020.
//

import SwiftUI

struct TimerPlay: View {
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    @State private var timerRunning = false
    @State private var circleState: CircleState = .one
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.init(.systemYellow))
                .frame(width: 64, height: 64)
                .offset(circleState.offset)
                .onReceive(timer) { _ in
                    withAnimation {
                        if timerRunning {
                            circleState = circleState.next()
                        }
                    }
                }
            
            VStack {
                Spacer()
                Button("Once") {
                    withAnimation {
                        circleState = circleState.next()
                    }
                }
                Button("\(timerRunning ? "Stop" : "Start") timer") {
                    timerRunning = !timerRunning
                }
            }
        }
    }
}

struct TimerContentView: View {
    var body: some View {
        ZStack {
            TimerPlay()
            SettingsView {
                VStack {
                    HStack {
                        Text("Rotation")
                    }
                    HStack {
                        Text("Duration")
                    }
                }
            }
        }
    }
}

enum CircleState {
    static let width: CGFloat = 100
    
    case one
    case two
    case three
    case four
    
    func next() -> CircleState {
        switch self {
        case .one: return .two
        case .two: return .three
        case .three: return .four
        case .four: return .one
        }
    }
    
    var offset: CGSize {
        switch self {
        case .one: return .init(width: -CircleState.width, height: -CircleState.width)
        case .two: return .init(width: CircleState.width, height: -CircleState.width)
        case .three: return .init(width: CircleState.width, height: CircleState.width)
        case .four: return .init(width: -CircleState.width, height: CircleState.width)
        }
    }
}

struct TimerPlay_Previews: PreviewProvider {
    static var previews: some View {
        TimerPlay()
    }
}
