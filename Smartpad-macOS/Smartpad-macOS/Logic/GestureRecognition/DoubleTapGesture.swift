//
//  DoubleTapGesture.swift
//  Smartpad-macOS
//
//  Created by Arthur Chan on 2022-03-19.
//

/**
 * Gesture handler for two-finger-tap. Causes a single mouse right click to occur.
 *
 * Required for the two-finger-tap/right click functional requirement FR6
 */

import Cocoa
import Foundation
import CoreGraphics

class DoubleTapGesture : Gesture {
    static let decoder = JSONDecoder()
    static let type = GestureType.DoubleTap

    static func performGesture(packet: GesturePacket) {
        assert(packet.touchType == type)
        
        if let screen = NSScreen.main {
            let rect = screen.frame
            let height = rect.size.height
            let mouseLocation = CGPoint(x: NSEvent.mouseLocation.x, y: height - NSEvent.mouseLocation.y)
            let source = CGEventSource(stateID: .hidSystemState)

            let rightMouseDownEvent = CGEvent(mouseEventSource: source, mouseType: .rightMouseDown, mouseCursorPosition: mouseLocation, mouseButton: .right)
            rightMouseDownEvent?.post(tap: .cghidEventTap)

            let rightMouseUpEvent = CGEvent(mouseEventSource: source, mouseType: .rightMouseUp, mouseCursorPosition: mouseLocation, mouseButton: .right)
            rightMouseUpEvent?.post(tap: .cghidEventTap)
        }
        
    }

    static func handlesGesture(gestureType: GestureType) -> Bool {
        return (type == gestureType)
    }
}
