//
//  PanGesture.swift
//  Smartpad-macOS
//
//  Created by Hudson Shykowski on 2022-03-19.
//

import Foundation
import AppKit

class PanGesture : Gesture {
    static let decoder = JSONDecoder()
    static let types = [GestureType.PanStarted, GestureType.PanChanged, GestureType.PanEnded]
    // Initial position when the "Started" packet is received
    static var initialPos: NSPoint?

    static let gain = Float(2.0) // TODO: Use settings class

    static func performGesture(packet: GesturePacket) {
        assert(types.contains(packet.touchType))

        guard let payload = try? decoder.decode(PanPayload.self, from: packet.payload)
        else {
            print("[PanGesture] Failed to decode payload!")
            return
        }

        print(packet.touchType!, " - xTrans: ", payload.xTranslation!, " yTrans: ", payload.yTranslation!)

        // Store the initial mouse position when we start panning
        // The conditions for starting panning are:
        // 1. We get a start packet
        // 2. We get a non-stat packet, but missed the start packet
        if (packet.touchType == GestureType.PanStarted || initialPos == nil) {
            initialPos = NSEvent.mouseLocation
        }

        // Calculate the new mouse position (from the original position)
        // TODO: A bit janky on a secondary screen, but works fine on primary screen
        let newPos = CGPoint(x: initialPos!.x + CGFloat(payload.xTranslation * gain),
                             y: NSScreen.main!.frame.height - initialPos!.y + CGFloat(payload.yTranslation * gain))
        CGDisplayMoveCursorToPoint(CGMainDisplayID(), newPos)

        // Reset the initialPos to nil when ending a pan
        if (packet.touchType == GestureType.PanEnded) {
            initialPos = nil
        }
    }

    static func handlesGesture(gestureType: GestureType) -> Bool {
        return types.contains(gestureType)
    }
}
