//
//  HapticsHelper.swift
//  GesturePlay
//
//  Created by Martin Wiingaard on 02/11/2020.
//

import Foundation
import CoreHaptics

class HapticsHelper {
    
    private var engine: CHHapticEngine?
    
    static let shared = HapticsHelper()
    
    func singleTap() {
        // make sure that the device supports haptics
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()

        // create one intense, sharp tap
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let event = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [intensity, sharpness],
            relativeTime: 0
        )
        events.append(event)

        // convert those events into a pattern and play it immediately
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
    
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            self.engine = try CHHapticEngine()
            try engine?.start()
            
            engine?.stoppedHandler = { reason in
                print("Stop Handler: The engine stopped for reason: \(reason.rawValue)")
                switch reason {
                case .audioSessionInterrupt: print("Audio session interrupt")
                case .applicationSuspended: print("Application suspended")
                case .idleTimeout: print("Idle timeout")
                case .systemError: print("System error")
                case .notifyWhenFinished: print("notifyWhenFinished")
                case .engineDestroyed: print("engineDestroyed")
                case .gameControllerDisconnect: print("gameControllerDisconnect")
                @unknown default: print("Default: \(reason)")
                }
            }
            
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
}
