//
//  SinglePanGesture.swift
//  Smartpad-macOS
//
//  Created by Hudson Shykowski on 2022-03-19.
//

import Foundation
import AppKit

class SinglePanGesture : Gesture {
    static let decoder = JSONDecoder()
    static let types = [GestureType.SinglePanStarted,
                        GestureType.SinglePanChanged,
                        GestureType.SinglePanEnded]
    // Initial position when the "Started" packet is received
    static var initialPos: NSPoint?

    static func performGesture(packet: GesturePacket) {
        assert(handlesGesture(gestureType: packet.touchType))

        guard let payload = try? decoder.decode(PanPayload.self, from: packet.payload)
        else {
            print("[SinglePanGesture] Failed to decode payload!")
            return
        }

//        print(packet.touchType!, " - xTrans: ", payload.xTranslation!, " yTrans: ", payload.yTranslation!)

        // Store the initial mouse position when we start panning
        // The conditions for starting panning are:
        // 1. We get a start packet
        // 2. We get a non-stat packet, but missed the start packet
        if (packet.touchType == GestureType.SinglePanStarted || initialPos == nil) {
            initialPos = NSEvent.mouseLocation
        }

        // Calculate the new mouse position (from the original position)
        // TODO: A bit janky on a secondary screen, but works fine on primary screen
        let newPos = CGPoint(x: initialPos!.x + CGFloat(payload.xTranslation * TrackpadSetting.getTrackingSpeed()),
                             y: NSScreen.main!.frame.height - initialPos!.y + CGFloat(payload.yTranslation * TrackpadSetting.getTrackingSpeed()))
        CGDisplayMoveCursorToPoint(CGMainDisplayID(), newPos)

        // Reset the initialPos to nil when ending a pan
        if (packet.touchType == GestureType.SinglePanEnded) {
            initialPos = nil
        }
    }

    static func handlesGesture(gestureType: GestureType) -> Bool {
        return types.contains(gestureType)
    }
}
