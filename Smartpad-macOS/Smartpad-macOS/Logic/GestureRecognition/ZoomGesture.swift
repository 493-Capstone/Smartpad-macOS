//
//  ZoomGesture.swift
//  Smartpad-macOS
//
//  Created by Hudson Shykowski on 2022-03-18.
//

import Foundation
import CoreGraphics
import Carbon.HIToolbox

class ZoomGesture : Gesture {
    static let decoder = JSONDecoder()
    static let types = [GestureType.PinchStarted, GestureType.PinchChanged, GestureType.PinchEnded]
    static var currentScale: Float?

    /* Absolute scale threshold. If less than -threshold, scale out. If greater than threshold, scale in. */
    static let threshold = Float(0.3) // TODO: Use settings class

    static func performGesture(packet: GesturePacket) {
        assert(handlesGesture(gestureType: packet.touchType))

        guard let payload = try? decoder.decode(PinchPayload.self, from: packet.payload)
        else {
            print("[ZoomGesture] Failed to decode payload!")
            return
        }

        // Set the initial scale when we start zooming
        // The conditions for starting zooming are:
        // 1. We get a start packet
        // 2. We get a non-stat packet, but missed the start packet
        if (packet.touchType == GestureType.PanStarted || currentScale == nil) {
            currentScale = 0.0
        }

        // Update the scale incrementally
        currentScale! += (payload.scale - 1.0)

        print("Pinch currentScale: ", currentScale!)

        // Check the upper and lower threshold for zoom in/out
        if (currentScale! <= -threshold) {
            zoomOut()

            // Reset scale for next time
            currentScale = 0.0
        }
        else if (currentScale! >= threshold) {
            zoomIn()

            // Reset scale for next time
            currentScale = 0.0
        }

        // Reset the scale to nil when ending a pan
        if (packet.touchType == GestureType.PinchEnded) {
            currentScale = nil
        }
    }

    static func handlesGesture(gestureType: GestureType) -> Bool {
        return types.contains(gestureType)
    }

    static private func zoomIn() {
        let cmdDown = CGEvent.init(keyboardEventSource: CGEventSource(stateID: .privateState),
                                   virtualKey: CGKeyCode(kVK_Command), keyDown: true)
        let cmdUp = CGEvent.init(keyboardEventSource: CGEventSource(stateID: .hidSystemState),
                                 virtualKey: CGKeyCode(kVK_Command), keyDown: false)
        let plusDown = CGEvent.init(keyboardEventSource: CGEventSource(stateID: .hidSystemState),
                                    virtualKey: CGKeyCode(kVK_ANSI_KeypadPlus), keyDown: true)
        let plusUp = CGEvent.init(keyboardEventSource: CGEventSource(stateID: .hidSystemState),
                                    virtualKey: CGKeyCode(kVK_ANSI_KeypadPlus), keyDown: true)

        // Indicates that the command key is down when we press or release +
        plusDown?.flags = CGEventFlags.maskCommand
        plusUp?.flags = CGEventFlags.maskCommand

        // Press CMD+
        cmdDown?.post(tap: .cghidEventTap)
        plusDown?.post(tap: .cghidEventTap)
        // Release CMD+
        cmdUp?.post(tap: .cghidEventTap)
        plusUp?.post(tap: .cghidEventTap)
    }

    static private func zoomOut() {
        let cmdDown = CGEvent.init(keyboardEventSource: CGEventSource(stateID: .privateState),
                                   virtualKey: CGKeyCode(kVK_Command), keyDown: true)
        let cmdUp = CGEvent.init(keyboardEventSource: CGEventSource(stateID: .hidSystemState),
                                 virtualKey: CGKeyCode(kVK_Command), keyDown: false)
        let minusDown = CGEvent.init(keyboardEventSource: CGEventSource(stateID: .hidSystemState),
                                    virtualKey: CGKeyCode(kVK_ANSI_KeypadMinus), keyDown: true)
        let minusUp = CGEvent.init(keyboardEventSource: CGEventSource(stateID: .hidSystemState),
                                    virtualKey: CGKeyCode(kVK_ANSI_KeypadMinus), keyDown: true)

        // Indicates that the command key is down when we press or release -
        minusDown?.flags = CGEventFlags.maskCommand
        minusUp?.flags = CGEventFlags.maskCommand

        // Press CMD-
        cmdDown?.post(tap: .cghidEventTap)
        minusDown?.post(tap: .cghidEventTap)
        // Release CMD-
        cmdUp?.post(tap: .cghidEventTap)
        minusUp?.post(tap: .cghidEventTap)
    }
}
