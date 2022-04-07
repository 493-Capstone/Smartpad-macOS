//
//  MainViewController.swift
//  Smartpad-macOS
//
//  Created by Alireza Azimi on 2022-03-19.
//

/**
 * Main view controller. Controls the main application view.
 *
 * Required for all MacOS functional requirements.
 *
 * Required for user interface requirements UIR-3 (device pairing UI), and UIR-4 (receiving gesture data)
 */

import Foundation
import Cocoa
import CoreGraphics

class MainViewController: NSViewController {
    @IBOutlet weak var pairingLabel: NSTextField!
    @IBOutlet weak var pairButton: NSButton!
    
    @IBOutlet weak var settingsXConstraint: NSLayoutConstraint!
    var originalConstraint: CGFloat!
    var centeredConstraint: CGFloat!
    var connectionManager: ConnectionManager!
    var deviceList: [String] = []
    var selectedDevice = ""
    var connData: ConnectionData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        originalConstraint = settingsXConstraint.constant
        centeredConstraint = originalConstraint - 54
        connectionManager = ConnectionManagerAccess.connectionManager
        connectionManager.mainVC = self
        connData = ConnectionData()
        let peerName = connData.getSelectedPeer(formatString: true)
        if(peerName  != ""){
            connectionManager.searchForDevices()
            self.updateConnStatus(status: ConnStatus.PairedAndDisconnected, peerName: peerName )
        }
        /* Now that we are in the main view controller, the settings button should be enabled */
        if #available(macOS 12.0, *) {
            (NSApp.delegate as! AppDelegate).setSettingsEnabled(isEnabled: true)
        }
    }

    /**
     * @brief Sets the text of the pairing information label
     * @param[in] text: The text to set the label to
     */
    func setPairLabel(text: String) {
        pairingLabel.stringValue = text
    }

    /**
     * @brief cetners the "settings" button
     */
    private func centerSettingsButton() {
        self.pairButton.isHidden = true
        self.settingsXConstraint.constant = self.centeredConstraint
    }

    /**
     * @brief Called by ConnectionManager whenever the ConnStatus changes. This updates all UI elements to reflect
     *        the current connection status.
     */
    func updateConnStatus(status: ConnStatus, peerName: String) {
        DispatchQueue.main.async {
            switch status {
                case .PairedAndConnected:
                    self.setPairLabel(text: "Paired to \(peerName)")
                    self.centerSettingsButton()
            
                                    
                case .PairedAndDisconnected:
                    self.setPairLabel(text: "Disconnected, attempting to reconnect...")
                    self.centerSettingsButton()

                case .Unpaired:
                    self.setPairLabel(text: "No device paired")
                    self.pairButton.isHidden = false
                    self.settingsXConstraint.constant = self.originalConstraint
            }

            if #available(macOS 12.0, *) {
                (NSApp.delegate as! AppDelegate).updateConnMenuStatus(status: status)
            }

            (self.view as! MainView).status = status
            self.view.setNeedsDisplay(NSRect(x: 0,y: 0,width: 500,height: 500))
        }
    }

    /**
     * @brief Callback for when the settings button is clicked
     */
    @IBAction func settingsButtonSelected(_ sender: NSButton) {
        showSettingsPage()
    }

    /**
     * @brief Shows the settings page
     */
    func showSettingsPage() {
        /* This is triggered either by the settings button or through the settings menu option in the Mac menu bar */
        let settingsVc = storyboard?.instantiateController(withIdentifier: "settings") as! SettingsViewController

        self.presentAsSheet(settingsVc)
    }
}

