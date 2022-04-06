//
//  GestureGenerator.swift
//  Smartpad-macOS
//
//  Created by Hudson Shykowski on 2022-03-18.
//

/**
 * Class for returning gesture handlers for a given gesture packet type. Part of the generator pattern.
 *
 * Required for all gesture functional requirements (FR5 - FR10)
 */

import Foundation

class GestureGenerator {
#if LATENCY_TEST_SUITE
    /* For latency testing, we only expect to receive latency packets */
    static let gestures: [Gesture.Type] = [LatencyGesture.self]
#else
    // Array of all classes that implement Gesture
    static let gestures: [Gesture.Type] = [ZoomGesture.self, SingleTapGesture.self, SingleTapDoubleClickGesture.self, DoubleTapGesture.self, SinglePanGesture.self, DoublePanGesture.self, DragPanGesture.self]
#endif // LATENCY_TEST_SUITE

    static func getGesture(type: GestureType) -> Gesture.Type {
        for gesture in gestures {
            if (gesture.handlesGesture(gestureType: type)) {
                return gesture
            }
        }

        // Unknown gesture type!
        assert(false);
    }
}
