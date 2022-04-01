//
//  SettingManager.swift
//  Smartpad-macOS
//
//  Created by Arthur Chan on 2022-03-22.
//

import Foundation

class TrackpadSetting {
    static private var reverseScrollingEnabled: Bool! = UserDefaults.standard.bool(forKey: "reverseScrollingEnabled")
    static private var trackingSpeed: Float! = UserDefaults.standard.float(forKey: "trackingSpeed")
    
    static public func enableReverseScrolling() {
        TrackpadSetting.reverseScrollingEnabled = true
        UserDefaults.standard.set(true, forKey: "reverseScrollingEnabled")
        UserDefaults.standard.synchronize()
    }
    
    static public func disableReverseScrolling() {
        TrackpadSetting.reverseScrollingEnabled = false
        UserDefaults.standard.set(false, forKey: "reverseScrollingEnabled")
        UserDefaults.standard.synchronize()
    }
    
    static public func isReverseScrollingEnabled() -> Bool {
        return TrackpadSetting.reverseScrollingEnabled
    }
    
    static public func getTrackingSpeed() -> Float {
        if (TrackpadSetting.trackingSpeed == nil) {
            return 2.0 // default trackingspeed
        }
        return TrackpadSetting.trackingSpeed
    }
    
    static public func setTrackingSpeed(speed: Float) {
        TrackpadSetting.trackingSpeed = speed / 50.0 + 1.0
        UserDefaults.standard.set(TrackpadSetting.trackingSpeed, forKey: "trackingSpeed")
        UserDefaults.standard.synchronize()
    }
}
