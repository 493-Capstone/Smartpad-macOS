//
//  SettingManager.swift
//  Smartpad-macOS
//
//  Created by Arthur Chan on 2022-03-22.
//

import Foundation

class TrackpadSetting {
    static private var reverseScrollingEnabled: Bool = false
    
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
}
