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
        
        let mouseLocation = NSEvent.mouseLocation
        let source = CGEventSource(stateID: .hidSystemState)
        let event = CGEvent.init(mouseEventSource: source, mouseType: .leftMouseDown, mouseCursorPosition: mouseLocation, mouseButton: .left)
        event?.post(tap: .cghidEventTap)
    }

    static func getGesture() -> GestureType {
        return type
    }
}
