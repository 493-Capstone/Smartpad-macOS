//
//  DoubleTapGesture.swift
//  Smartpad-macOS
//
//  Created by Arthur Chan on 2022-03-19.
//

import Foundation

class DoubleTapGesture : Gesture {
    static let decoder = JSONDecoder()
    static let type = GestureType.DoubleTap

    static func performGesture(packet: GesturePacket) {
        assert(packet.touchType == type)

        guard let payload = try? decoder.decode(DoubleTapPayload.self, from: packet.payload)
        else {
            print("[ZoomGesture] Failed to decode payload!")
            return
        }

        print("DoubleTap")
    }

    static func getGesture() -> GestureType {
        return type
    }
}
