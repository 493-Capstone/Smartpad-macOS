//
//  ZoomGesture.swift
//  Smartpad-macOS
//
//  Created by Hudson Shykowski on 2022-03-18.
//

import Foundation

class ZoomGesture : Gesture {
    static let decoder = JSONDecoder()
    static let type = GestureType.Pinch

    static func performGesture(packet: GesturePacket) {
        assert(packet.touchType == type)

        guard let payload = try? decoder.decode(PinchPayload.self, from: packet.payload)
        else {
            print("[ZoomGesture] Failed to decode payload!")
            return
        }

//        print("Pinch - xScale: ", payload.xScale!, "yScale: ", payload.yScale!)
        // TODO: Actually pinch (How to do this??)
    }

    static func handlesGesture(gestureType: GestureType) -> Bool {
        return (type == gestureType)
    }
}
