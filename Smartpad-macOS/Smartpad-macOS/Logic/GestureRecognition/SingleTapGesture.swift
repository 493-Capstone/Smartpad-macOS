//
//  SingleTapGesture.swift
//  Smartpad-macOS
//
//  Created by Arthur Chan on 2022-03-18.
//

import Foundation

class SingleTapGesture : Gesture {
    static let decoder = JSONDecoder()
    static let type = GestureType.SingleTap

    static func performGesture(packet: GesturePacket) {
        assert(packet.touchType == type)

        guard let payload = try? decoder.decode(SingleTapPayload.self, from: packet.payload)
        else {
            print("[ZoomGesture] Failed to decode payload!")
            return
        }

        print("SingleTap")
    }

    static func getGesture() -> GestureType {
        return type
    }
}
