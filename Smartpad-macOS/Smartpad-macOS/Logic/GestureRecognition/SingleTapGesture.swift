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
        
        if let screen = NSScreen.main {
            let rect = screen.frame
            let height = rect.size.height
            let mouseLocation = CGPoint(x: NSEvent.mouseLocation.x, y: height - NSEvent.mouseLocation.y)
            let source = CGEventSource(stateID: .hidSystemState)
            let leftMouseDownEvent = CGEvent(mouseEventSource: source, mouseType: .leftMouseDown, mouseCursorPosition: mouseLocation, mouseButton: .left)
            leftMouseDownEvent?.post(tap: .cghidEventTap)
            let leftMouseUpvent = CGEvent(mouseEventSource: source, mouseType: .leftMouseUp, mouseCursorPosition: mouseLocation, mouseButton: .left)
            leftMouseUpvent?.post(tap: .cghidEventTap)
        }
    }

    static func handlesGesture(gestureType: GestureType) -> Bool {
        return (type == gestureType)
    }
}
