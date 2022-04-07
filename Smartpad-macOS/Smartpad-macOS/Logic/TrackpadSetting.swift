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

struct SettingsKeys {
    static let reverseScrollEnabled = "reverseScrollEnabled"
    static let trackingSpeed = "trackingSpeed"
}

class TrackpadSetting {
    static let defaults = UserDefaults.standard

    /**
     * @brief Enable reverse scrolling.
     */
    static public func enableReverseScrolling() {
        defaults.set(true, forKey: SettingsKeys.reverseScrollEnabled)
        defaults.synchronize()
    }

    /**
     * @brief Disable reverse scrolling.
     */
    static public func disableReverseScrolling() {
        defaults.set(false, forKey: SettingsKeys.reverseScrollEnabled)
        defaults.synchronize()
    }

    /**
     * @brief Checks if reverse scrolling is enabled
     *
     * @return Bool: If reverse scrolling is enabled
     */
    static public func isReverseScrollingEnabled() -> Bool {
        return defaults.bool(forKey: SettingsKeys.reverseScrollEnabled)
    }

    /**
     * @brief Update the tracking speed value.
     */
    static public func setTrackingSpeed(speed: Float) {
        let newTrackSpeed = speed / 50.0 + 1.0
        defaults.set(newTrackSpeed, forKey: SettingsKeys.trackingSpeed)
        defaults.synchronize()
    }

    /**
     * @brief Get the current trackpad speed
     *
     * @return Float: The current trackpad speed
     */
    static public func getTrackingSpeed() -> Float {
        let trackingSpeed = defaults.float(forKey: SettingsKeys.trackingSpeed)

        if (trackingSpeed == 0.0) {
            /* The tracking speed was never set, return a default of 2.0 */
            return 2.0
        }
        else {
            return trackingSpeed
        }
    }
}
