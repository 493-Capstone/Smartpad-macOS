//
//  DragPanGesture.swift
//  Smartpad-macOS
//
//  Created by Hudson Shykowski on 2022-03-22.
//

/**
 * Gesture handler for finger hold then pan. Causes mouse click-and-drag to occur.
 *
 * Required for the drag pan functional requirement FR7
 */

import Foundation
import AppKit
import CoreGraphics

class DragPanGesture : Gesture {
    static let decoder = JSONDecoder()
    static let types = [GestureType.DragPanStarted,
                        GestureType.DragPanChanged,
                        GestureType.DragPanEnded]

    // Initial position when the "Started" packet is received
    static var initialPos: NSPoint?

    static func performGesture(packet: GesturePacket) {
        assert(handlesGesture(gestureType: packet.touchType))

        guard let payload = try? decoder.decode(PanPayload.self, from: packet.payload)
        else {
            print("[SinglePanGesture] Failed to decode payload!")
            return
        }

        // Store the initial mouse position when we start panning
        // The conditions for starting panning are:
        // 1. We get a start packet
        // 2. We get a non-stat packet, but missed the start packet
        if (packet.touchType == GestureType.DragPanStarted || initialPos == nil) {
            initialPos = NSEvent.mouseLocation
            click(down: true)
        }

        // Calculate the new mouse position (from the original position)
        // TODO: A bit janky on a secondary screen, but works fine on primary screen
        var newPos = CGPoint(x: initialPos!.x +
                                CGFloat(payload.xTranslation * TrackpadSetting.getTrackingSpeed()),
                             y: NSScreen.main!.frame.height - initialPos!.y +
                                CGFloat(payload.yTranslation * TrackpadSetting.getTrackingSpeed()))
        
        // restrict coordinates to screen size
        if newPos.y > NSScreen.main!.frame.height {
            newPos.y = NSScreen.main!.frame.height
        } else if newPos.y < 0 {
            newPos.y = 0
        }
        // restrict coordinates to screen size
        if newPos.x > NSScreen.main!.frame.width {
            newPos.x = NSScreen.main!.frame.width
        } else if newPos.x < 0 {
            newPos.x = 0
        }

        dragMouse(position: newPos)

        // Reset the initialPos to nil when ending a pan
        if (packet.touchType == GestureType.DragPanEnded) {
            initialPos = nil
            click(down: false)
        }
    }

    static func handlesGesture(gestureType: GestureType) -> Bool {
        return types.contains(gestureType)
    }

    /**
     * @brief drag the mouse. This must be preceded by a mouse click down, and followed up
     *      with a mouse click up.
     */
    static private func dragMouse(position: CGPoint) {
        let mouseEvent = CGEvent(mouseEventSource: CGEventSource(stateID: .hidSystemState),
                                 mouseType: CGEventType.leftMouseDragged,
                                 mouseCursorPosition: position, mouseButton: .left)
        mouseEvent?.post(tap: .cghidEventTap)
    }

    /**
     * @brief click the mouse
     * @param[in] down: True if we are clicking down, false if we are clicking up
     */
    static private func click(down: Bool) {
        let mouseType = (down) ? (CGEventType.leftMouseDown) :
                                 (CGEventType.leftMouseUp)

        if let screen = NSScreen.main {
            let rect = screen.frame
            let height = rect.size.height
            let mouseLocation = CGPoint(x: NSEvent.mouseLocation.x, y: height - NSEvent.mouseLocation.y)
            let source = CGEventSource(stateID: .hidSystemState)

            let mouseEvent = CGEvent(mouseEventSource: source, mouseType: mouseType,
                                     mouseCursorPosition: mouseLocation, mouseButton: .left)
            mouseEvent?.post(tap: .cghidEventTap)
        }
    }
}
