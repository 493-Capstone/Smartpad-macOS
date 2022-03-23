//
//  SettingManager.swift
//  Smartpad-macOS
//
//  Created by Arthur Chan on 2022-03-22.
//

import Foundation

class TrackpadSetting {
    static private var reverseScrollingEnabled: Bool = true
    static private var trackingSpeed: Float = 2.0;
    
    static public func enableTrackpadSetting() {
        TrackpadSetting.reverseScrollingEnabled = true
        print("enable reverse scrolling")
    }
    
    static public func disableTrackpadSetting() {
        TrackpadSetting.reverseScrollingEnabled = false
        print("disable reverse scrolling")
    }
    
    static public func isReverseScrollingEnabled() -> Bool {
        return TrackpadSetting.reverseScrollingEnabled
    }
    
    static public func getTrackingSpeed() -> Float {
        return TrackpadSetting.trackingSpeed
    }
    
    static public func setTrackingSpeed(speed: Float) {
        TrackpadSetting.trackingSpeed = speed / 50.0 + 1.0
        print("set tracking speed to \(TrackpadSetting.trackingSpeed)")
    }
}
