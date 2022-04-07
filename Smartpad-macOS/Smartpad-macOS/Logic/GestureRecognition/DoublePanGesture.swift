//
//  DoublePanGesture.swift
//  Smartpad-macOS
//
//  Created by Hudson Shykowski on 2022-03-19.
//

/**
 * Gesture handler for two-finger-pan. Causes mouse scrolls to occur.
 *
 * Required for the two-finger-tap/right click functional requirement FR9
 */

import Foundation
import AppKit
import CoreGraphics

class DoublePanGesture : Gesture {
    static let decoder = JSONDecoder()
    static let types = [GestureType.DoublePanStarted,
                        GestureType.DoublePanChanged,
                        GestureType.DoublePanEnded]

    /* Last position received */
    static var lastPos: CGPoint?

    static func performGesture(packet: GesturePacket) {
        assert(types.contains(packet.touchType))

        guard let payload = try? decoder.decode(PanPayload.self, from: packet.payload)
        else {
            print("[DoublePanGesture] Failed to decode payload!")
            return
        }

        // Set the initial distance travelled when we start panning
        // The conditions for starting panning are:
        // 1. We get a start packet
        // 2. We get a non-stat packet, but missed the start packet
        if (packet.touchType == GestureType.DoublePanStarted || lastPos == nil) {
            lastPos = CGPoint(x: Double(payload.xTranslation), y: Double(payload.yTranslation))
        }
        else if (packet.touchType == GestureType.DoublePanChanged) {
            /* Calculate the difference between the last and current position */
            var xPixels = Int32(floor(((payload.xTranslation!)
                                       - Float(lastPos!.x)) * TrackpadSetting.getTrackingSpeed()))
            var yPixels = Int32(floor(((payload.yTranslation!)
                                       - Float(lastPos!.y)) * TrackpadSetting.getTrackingSpeed()))

            if (TrackpadSetting.isReverseScrollingEnabled()) {
                xPixels = -xPixels
                yPixels = -yPixels
            }

            mouseScroll(xPixels: xPixels, yPixels: yPixels)

            /* Update the last position for use next time */
            lastPos = CGPoint(x: Double(payload.xTranslation), y: Double(payload.yTranslation))
        }
        else if (packet.touchType == GestureType.DoublePanEnded) {
            // Reset last pos
            lastPos = nil
        }
    }

    static func handlesGesture(gestureType: GestureType) -> Bool {
        return types.contains(gestureType)
    }

    /**
     * @brief cause a mouse scroll event
     * @param[in] xPixels: Number of pixels in the x direction to scroll
     * @param[in] yPixels: Number of pixels in the y direction to scroll
     */
    static private func mouseScroll(xPixels: Int32, yPixels: Int32) {
        guard let scrollEvent = CGEvent(scrollWheelEvent2Source: nil, units: .pixel, wheelCount: 2, wheel1: yPixels, wheel2: xPixels, wheel3: 0) else {
            print("Failed to scroll mouse")
            return
        }

        scrollEvent.post(tap: .cghidEventTap)
    }
}
