//
//  GestureGenerator.swift
//  Smartpad-macOS
//
//  Created by Hudson Shykowski on 2022-03-18.
//

import Foundation

class GestureGenerator {
    // Array of all classes that implement Gesture
    static let gestures: [Gesture.Type] = [ZoomGesture.self, SingleTapGesture.self, DoubleTapGesture.self]

    static func getGesture(type: GestureType) -> Gesture.Type {
        for gesture in gestures {
            if (gesture.getGesture() == type) {
                return gesture
            }
        }

        // Unknown gesture type!
        assert(false);
    }
}
