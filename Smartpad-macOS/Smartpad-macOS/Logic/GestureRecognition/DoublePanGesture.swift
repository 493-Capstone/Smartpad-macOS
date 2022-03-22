//
//  DoublePanGesture.swift
//  Smartpad-macOS
//
//  Created by Hudson Shykowski on 2022-03-19.
//

import Foundation

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

    static let gain = Float(2.0) // TODO: Use settings class
    static let inverted = true // TODO: User settings class

    static func performGesture(packet: GesturePacket) {
        assert(types.contains(packet.touchType))

        guard let payload = try? decoder.decode(PanPayload.self, from: packet.payload)
        else {
            print("[DoublePanGesture] Failed to decode payload!")
            return
        }

        // We allow both X and Y scrolls, so track them both
//        print(packet.touchType!, " - xTrans: ", payload.xTranslation!, " yTrans: ", payload.yTranslation!)

        // Set the initial distance travelled when we start panning
        // The conditions for starting panning are:
        // 1. We get a start packet
        // 2. We get a non-stat packet, but missed the start packet
        if (packet.touchType == GestureType.DoublePanStarted || lastPos == nil) {
            lastPos = CGPoint(x: Double(payload.xTranslation), y: Double(payload.yTranslation))
        }
        else if (packet.touchType == GestureType.DoublePanChanged) {
            /* Calculate the difference between the last and current position */
            var xPixels = Int32(floor(((payload.xTranslation!) - Float(lastPos!.x)) * gain))
            var yPixels = Int32(floor(((payload.yTranslation!) - Float(lastPos!.y)) * gain))

            if (inverted) {
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

    // TODO: Add momentum to scrolls to make it feel more natural
    // https://stackoverflow.com/questions/51519281/simulate-mouse-wheel-on-macos-swift-or-objc
    static private func mouseScroll(xPixels: Int32, yPixels: Int32) {
        guard let scrollEvent = CGEvent(scrollWheelEvent2Source: nil, units: .pixel, wheelCount: 2, wheel1: yPixels, wheel2: xPixels, wheel3: 0) else {
            print("Failed to scroll mouse")
            return
        }

        scrollEvent.post(tap: .cghidEventTap)
    }
}
