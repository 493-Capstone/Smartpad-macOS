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

//        print("DoubleTap")
        
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
