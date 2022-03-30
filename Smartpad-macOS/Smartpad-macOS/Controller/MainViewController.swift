//
//  MainViewController.swift
//  Smartpad-macOS
//
//  Created by Alireza Azimi on 2022-03-19.
//

import Foundation
import Cocoa
import CoreGraphics

class MainViewController: NSViewController {

    @IBOutlet weak var pairingLabel: NSTextField!
    var connectionManager: ConnectionManager!
    var deviceList: [String] = []
    var selectedDevice = ""
    var connData: ConnectionData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connectionManager = ConnectionManagerAccess.connectionManager
        connectionManager.mainVC = self
        connData = ConnectionData()

        /* Now that we are in the main view controller, the settings button should be enabled */
        if #available(macOS 12.0, *) {
            (NSApp.delegate as! AppDelegate).setSettingsEnabled(isEnabled: true)
        }
    }
    func setPairLabel(label: String){
        pairingLabel.stringValue = label
    }

    /**
     * @brief Called by ConnectionManager whenever the ConnStatus changes. This updates all UI elements to reflect
     *        the current connection status.
     */
    func updateConnStatus(status: ConnStatus, peerName: String) {
        DispatchQueue.main.async {
            switch status {
                case .PairedAndConnected:
                    self.setPairLabel(label: "Connected: \(peerName)")

                case .PairedAndDisconnected:
                    self.setPairLabel(label: "Disconnected, attempting to reconnect...")

                case .Unpaired:
                    self.setPairLabel(label: "No device connected")
            }

            if #available(macOS 12.0, *) {
                (NSApp.delegate as! AppDelegate).updateConnMenuStatus(status: status)
            }

            (self.view as! MainView).status = status
            self.view.setNeedsDisplay(NSRect(x: 0,y: 0,width: 500,height: 500))
        }
    }
    

    @IBAction func settingsButtonSelected(_ sender: NSButton) {
        /* The "settings" button was pressed */
        showSettingsPage()
    }

    func showSettingsPage() {
        /* This is triggered either by the settings button or through the settings menu option in the Mac menu bar */
        let settingsVc = storyboard?.instantiateController(withIdentifier: "settings") as! SettingsViewController

        self.presentAsSheet(settingsVc)
    }
}

