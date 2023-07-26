//
//  DispatchPlay.swift
//  GesturePlay
//
//  Created by Martin Wiingaard on 22/11/2020.
//

import SwiftUI
import Combine

struct DispatchPlay: View {
    
    var passthrough = PassthroughSubject<DispatchState, Never>()
    
    @State private var timerRunning = false
    @State private var circleState: DispatchState = .rest
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.init(.systemRed))
                .frame(width: 64, height: 64)
                .offset(.init(width: 0, height: circleState.offset))
                .onReceive(passthrough) { state in
                    withAnimation(Animation.easeOut(duration: 0.3)) {
                        circleState = state
                    }
                }
                
                
            VStack {
                Spacer()
                Button("Once") {
                    passthrough.send(circleState.next())
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        passthrough.send(.two)
                    }
                    
                }
                
                Button("Reset") {
                    circleState = .rest
                }
            }
        }
    }
}

struct DispatchContentView: View {
    var body: some View {
        ZStack {
            DispatchPlay()
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

enum DispatchState {
    static let length: CGFloat = 100
    
    case rest
    case one
    case two
    
    func next() -> DispatchState {
        switch self {
        case .rest: return .one
        case .one: return .two
        case .two: return .rest
        }
    }
    
    var offset: CGFloat {
        switch self {
        case .rest: return 0
        case .one: return -DispatchState.length
        case .two: return 2*DispatchState.length
        }
    }
}

struct DispatchPlay_Previews: PreviewProvider {
    static var previews: some View {
        DispatchPlay()
    }
}

