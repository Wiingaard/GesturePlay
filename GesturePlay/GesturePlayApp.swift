//
//  GesturePlayApp.swift
//  GesturePlay
//
//  Created by Martin Wiingaard on 30/10/2020.
//

import SwiftUI

@main
struct GesturePlayApp: App {
    var body: some Scene {
        WindowGroup {
            DispatchPlay()
//            MainNavigationView().onAppear {
//                HapticsHelper.shared.prepareHaptics()
//            }
        }
    }
}
