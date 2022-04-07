//
//  ZoomGesture.swift
//  Smartpad-macOS
//
//  Created by Hudson Shykowski on 2022-03-18.
//

/**
 * Gesture handler for pinch. Causes zoom events to occur in the current window.
 *
 * Required for the pinch/zoom gesture functional requirement FR10
 */

import Foundation
import CoreGraphics
import Carbon.HIToolbox

class ZoomGesture : Gesture {
    static let decoder = JSONDecoder()
    static let types = [GestureType.PinchStarted, GestureType.PinchChanged, GestureType.PinchEnded]
    static var currentScale: Float?

    /* Absolute zoom threshold. If less than -threshold, scale out. If greater than threshold, scale in. */
    static let threshold = Float(0.3)

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
        if (packet.touchType == GestureType.PinchStarted || currentScale == nil) {
            currentScale = 0.0
        }

        // Update the scale incrementally
        currentScale! += (payload.scale - 1.0)

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

    /**
     * @brief Zoom in on the current window via the CMD+ keyboard shortcut
     */
    static private func zoomIn() {
        let plusDown = CGEvent.init(keyboardEventSource: CGEventSource(stateID: .hidSystemState),
                                    virtualKey: CGKeyCode(kVK_ANSI_KeypadPlus), keyDown: true)
        let plusUp = CGEvent.init(keyboardEventSource: CGEventSource(stateID: .hidSystemState),
                                    virtualKey: CGKeyCode(kVK_ANSI_KeypadPlus), keyDown: false)

        // Indicates that the command key is down when we press or release +
        plusDown?.flags = CGEventFlags.maskCommand
        plusUp?.flags = CGEventFlags.maskCommand

        // Press CMD+
        plusDown?.post(tap: .cghidEventTap)
        // Release CMD+
        plusUp?.post(tap: .cghidEventTap)
    }

    /**
     * @brief Zoom out on the current window via the CMD- keyboard shortcut
     */
    static private func zoomOut() {
        let minusDown = CGEvent.init(keyboardEventSource: CGEventSource(stateID: .hidSystemState),
                                    virtualKey: CGKeyCode(kVK_ANSI_KeypadMinus), keyDown: true)
        let minusUp = CGEvent.init(keyboardEventSource: CGEventSource(stateID: .hidSystemState),
                                    virtualKey: CGKeyCode(kVK_ANSI_KeypadMinus), keyDown: false)

        // Indicates that the command key is down when we press or release -
        minusDown?.flags = CGEventFlags.maskCommand
        minusUp?.flags = CGEventFlags.maskCommand

        // Press CMD-
        minusDown?.post(tap: .cghidEventTap)
        // Release CMD-
        minusUp?.post(tap: .cghidEventTap)
    }
}
