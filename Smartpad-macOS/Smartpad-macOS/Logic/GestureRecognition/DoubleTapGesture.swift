//
//  DoubleTapGesture.swift
//  Smartpad-macOS
//
//  Created by Arthur Chan on 2022-03-19.
//

import Cocoa
import Foundation
import CoreGraphics

class DoubleTapGesture : Gesture {
    static let decoder = JSONDecoder()
    static let type = GestureType.DoubleTap

    static func performGesture(packet: GesturePacket) {
        assert(packet.touchType == type)

        print("DoubleTap")
    }

    static func getGesture() -> GestureType {
        return type
    }
}
