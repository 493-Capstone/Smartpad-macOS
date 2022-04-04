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
    @IBOutlet weak var isPairedLabel: NSTextField!
    @IBOutlet weak var unpairButton: NSButton!
    @IBOutlet weak var changeNameLabel: NSTextField!
    @IBOutlet weak var changeNameField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /* Show the current device name */
        changeNameField.stringValue = ConnectionData().getDeviceName()

        updateConnUI()

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

    /**
     * Called when the view is about to disapear.
     */
    override func viewWillDisappear() {
        super.viewWillDisappear()

        /* Disable the name field when closing to prevent auto-submitting the device name field on close */
        changeNameField.isEnabled = false
    }

    /**
     * @brief Update the portions of the UI that are dependent on whether we are paired or not
     */
    private func updateConnUI() {
        let connData = ConnectionData()

        /* If we have a peer, show the paired UI, otherwise treat as unpaired */
        if (connData.getSelectedPeer() == "") {
            isPairedLabel.stringValue = "Device is unpaired"
            unpairButton.isHidden = true

            changeNameLabel.stringValue = "Change device name:"
            changeNameField.isEnabled = true
        }
        else {
            isPairedLabel.stringValue = "Paired to \(connData.getSelectedPeer(formatString: true))"
            unpairButton.isHidden = false

            changeNameLabel.stringValue = "Changing name is not available when paired"
            changeNameField.isEnabled = false
        }
    }
    
    @IBAction func unpairDevice(_ sender: NSButton) {
        ConnectionManagerAccess.connectionManager.unpairDevice()
        updateConnUI()
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

    @IBAction func deviceNameSubmitted(_ sender: NSTextField) {
        let name = sender.stringValue

        if (name != "") {
            /* Update the name */
            ConnectionData().setDeviceName(name: name)
        }
        else {
            /* Empty name, show a warning */
            NameEmptyAlert().runModal()
        }
    }
}

