//
//  SingleTapGesture.swift
//  Smartpad-macOS
//
//  Created by Arthur Chan on 2022-03-18.
//

import Cocoa
import Foundation
import CoreGraphics

class SingleTapGesture : Gesture {
    static let decoder = JSONDecoder()
    static let type = GestureType.SingleTap

    static func performGesture(packet: GesturePacket) {
        assert(packet.touchType == type)

        print("SingleTap")
    }

    static func getGesture() -> GestureType {
        return type
    }
}
