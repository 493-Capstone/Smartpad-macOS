//
//  MainView.swift
//  Smartpad-macOS
//
//  Created by Alireza Azimi on 2022-03-24.
//

/**
 * Draws the connection status circle.
 *
 * Required for connection status functional requirement FR16
 *
 * Required for user interface requirement UIR-5 (device reconnect UI)
 */

import Foundation
import AppKit

class MainView: NSView {
    var status: ConnStatus = ConnStatus.Unpaired
    
    override func draw(_ rect: CGRect) {
        drawConnStatus()
    }

    /**
     * @brief: Draws the connection indicator in the center of the window
     */
    func drawConnStatus() {
        var path = NSBezierPath()
        path = NSBezierPath(ovalIn: CGRect(x: self.bounds.midX - 100, y: self.bounds.midY - 100, width: 200, height: 200))
        switch status {
            case ConnStatus.Unpaired:
                NSColor.red.setStroke()
                NSColor.red.setFill()

            case ConnStatus.PairedAndDisconnected:
                NSColor.yellow.setStroke()
                NSColor.yellow.setFill()

            case ConnStatus.PairedAndConnected:
                NSColor.green.setStroke()
                NSColor.green.setFill()
        }

        NSColor.black.setStroke()

        path.lineWidth = 5
        path.stroke()
        path.fill()
    }
}
