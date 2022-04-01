//
//  SettingsViewController.swift
//  Smartpad-macOS
//
//  Created by Arthur Chan on 2022-03-22.
//

import Foundation
import Cocoa
import CoreGraphics

class SettingsViewController: NSViewController{
    
    @IBOutlet weak var reverseScrollingCheckbox: NSButton!
    @IBOutlet weak var trackingSpeedSlider: NSSlider!

    override func viewDidLoad() {
        super.viewDidLoad()
        if (UserDefaults.standard.bool(forKey: "reverseScrollingEnabled")) {
            reverseScrollingCheckbox.state = .on
        } else {
            reverseScrollingCheckbox.state = .off
        }
        let storedTrackingSpeed: Double!
        storedTrackingSpeed = UserDefaults.standard.double(forKey: "trackingSpeed")
        if (storedTrackingSpeed == nil) {
            trackingSpeedSlider.doubleValue = 50.0
        }
        trackingSpeedSlider.doubleValue = (UserDefaults.standard.double(forKey: "trackingSpeed") - 1) * 50
    }
    
    @IBAction func reverseScrollingSelected(_ sender: NSButton) {
        if sender.state == .on {
            TrackpadSetting.enableReverseScrolling()
        } else {
            TrackpadSetting.disableReverseScrolling()
        }
    }
    
    @IBAction func trackSpeedChanged(_ sender: NSSlider) {
        TrackpadSetting.setTrackingSpeed(speed: sender.floatValue)
    }

    @IBAction func closeButtonClicked(_ sender: NSButton) {
        dismiss(true)
    }
}

