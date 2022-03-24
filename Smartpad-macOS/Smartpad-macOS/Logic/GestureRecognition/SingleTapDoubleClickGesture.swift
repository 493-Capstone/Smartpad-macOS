//
//  SingleTapDoubleClickGesture.swift
//  Smartpad-macOS
//
//  Created by Arthur Chan on 2022-03-23.
//

import Cocoa
import Foundation
import CoreGraphics

class SingleTapDoubleClickGesture : Gesture {
    static let decoder = JSONDecoder()
    static let type = GestureType.SingleTapDoubleClick

    static func performGesture(packet: GesturePacket) {
        assert(packet.touchType == type)

//        print("DoubleTap")
        
        if let screen = NSScreen.main {
            let rect = screen.frame
            let height = rect.size.height
            let mouseLocation = CGPoint(x: NSEvent.mouseLocation.x, y: height - NSEvent.mouseLocation.y)
            let source = CGEventSource(stateID: .hidSystemState)

            let leftMouseDownEvent = CGEvent(mouseEventSource: source, mouseType: .leftMouseDown, mouseCursorPosition: mouseLocation, mouseButton: .left)
            leftMouseDownEvent?.setIntegerValueField(.mouseEventClickState, value: 2)
            leftMouseDownEvent?.post(tap: .cghidEventTap)

            let leftMouseUpEvent = CGEvent(mouseEventSource: source, mouseType: .leftMouseUp, mouseCursorPosition: mouseLocation, mouseButton: .left)
            leftMouseUpEvent?.setIntegerValueField(.mouseEventClickState, value: 2)
            leftMouseUpEvent?.post(tap: .cghidEventTap)
        }
    }

    static func handlesGesture(gestureType: GestureType) -> Bool {
        return (type == gestureType)
    }
}
