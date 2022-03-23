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
    }
    
    static public func disableTrackpadSetting() {
        TrackpadSetting.reverseScrollingEnabled = false
    }
    
    static public func isReverseScrollingEnabled() -> Bool {
        return TrackpadSetting.reverseScrollingEnabled
    }
    
    static public func getTrackingSpeed() -> Float {
        return TrackpadSetting.trackingSpeed
    }
    
    static public func setTrackingSpeed(speed: Float) {
        TrackpadSetting.trackingSpeed = speed / 50.0 + 1.0
    }
}
