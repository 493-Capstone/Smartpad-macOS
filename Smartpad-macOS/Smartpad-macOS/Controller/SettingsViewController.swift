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
    @IBOutlet weak var settingsLabel: NSTextField!
    @IBOutlet weak var unpairButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let connData = ConnectionData()
        
        if (connData.getSelectedPeer() != ""){
            print(connData.getSelectedPeer())
            setUIToPairedStatus()

        } else {
            setUIToUnpairedStatus()
        }
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
    
    private func setUIToUnpairedStatus(){
        settingsLabel.stringValue = "Device is unpaired"
        unpairButton.isHidden = true
    }
    
    private func setUIToPairedStatus(){
        settingsLabel.stringValue = "Device is paired"
        unpairButton.isHidden = false
    }
    
    @IBAction func unpairDevice(_ sender: NSButton) {
        ConnectionManagerAccess.connectionManager.unpairDevice()
        setUIToUnpairedStatus()
        
    }
    
    @IBAction func reverseScrollingSelected(_ sender: NSButton) {
        if sender.state == .on {
            TrackpadSetting.enableTrackpadSetting()
        } else {
            TrackpadSetting.disableTrackpadSetting()
        }
    }
    
    @IBAction func trackSpeedChanged(_ sender: NSSlider) {
        TrackpadSetting.setTrackingSpeed(speed: sender.floatValue)
    }

    @IBAction func closeButtonClicked(_ sender: NSButton) {
        dismiss(true)
    }
}

