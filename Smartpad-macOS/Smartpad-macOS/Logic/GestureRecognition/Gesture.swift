//
//  Gesture.swift
//  Smartpad-macOS
//
//  Created by Hudson Shykowski on 2022-03-18.
//

import Foundation

protocol Gesture {
    /**
     * @brief Perform a gesture based on a gesture packet.
     * @param[in] packet: A packet containing data about the gesture to perform. Will need to be decoded by the Gesture.
     */
    static func performGesture(packet: GesturePacket) -> Void

    /**
     * @brief Check if the gesture can handle a given GestureType
     */
    static func handlesGesture(gestureType: GestureType) -> Bool
}
