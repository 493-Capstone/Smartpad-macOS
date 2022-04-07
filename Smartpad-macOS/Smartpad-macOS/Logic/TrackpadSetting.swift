//
//  SettingManager.swift
//  Smartpad-macOS
//
//  Created by Arthur Chan on 2022-03-22.
//

/**
 * Class for setting or retrieving trackpad settings from the application database.
 *
 * Required for trackpad settings functional requirements FR12 and FR13
 */

import Foundation

class TrackpadSetting {
    static private var reverseScrollingEnabled: Bool! = UserDefaults.standard.bool(forKey: "reverseScrollingEnabled")
    static private var trackingSpeed: Float! = UserDefaults.standard.float(forKey: "trackingSpeed")

    /**
     * @brief Enable reverse scrolling.
     */
    static public func enableReverseScrolling() {
        TrackpadSetting.reverseScrollingEnabled = true
        UserDefaults.standard.set(true, forKey: "reverseScrollingEnabled")
        UserDefaults.standard.synchronize()
    }

    /**
     * @brief Disable reverse scrolling.
     */
    static public func disableReverseScrolling() {
        TrackpadSetting.reverseScrollingEnabled = false
        UserDefaults.standard.set(false, forKey: "reverseScrollingEnabled")
        UserDefaults.standard.synchronize()
    }

    /**
     * @brief Checks if reverse scrolling is enabled
     *
     * @return Bool: If reverse scrolling is enabled
     */
    static public func isReverseScrollingEnabled() -> Bool {
        return TrackpadSetting.reverseScrollingEnabled
    }

    /**
     * @brief Update the tracking speed value.
     */
    static public func setTrackingSpeed(speed: Float) {
        TrackpadSetting.trackingSpeed = speed / 50.0 + 1.0
        UserDefaults.standard.set(TrackpadSetting.trackingSpeed, forKey: "trackingSpeed")
        UserDefaults.standard.synchronize()
    }

    /**
     * @brief Get the current trackpad speed
     *
     * @return Float: The current trackpad speed
     */
    static public func getTrackingSpeed() -> Float {
        if (TrackpadSetting.trackingSpeed == nil) {
            return 2.0 // default trackingspeed
        }
        return TrackpadSetting.trackingSpeed
    }
}
