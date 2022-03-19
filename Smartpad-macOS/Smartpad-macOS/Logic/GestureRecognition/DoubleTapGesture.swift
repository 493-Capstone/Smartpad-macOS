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
        
        let mouseLocation = NSEvent.mouseLocation
        let source = CGEventSource(stateID: .hidSystemState)
        let event = CGEvent.init(mouseEventSource: source, mouseType: .rightMouseDown, mouseCursorPosition: mouseLocation, mouseButton: .right)
        event?.post(tap: .cghidEventTap)
    }

    static func getGesture() -> GestureType {
        return type
    }
}
