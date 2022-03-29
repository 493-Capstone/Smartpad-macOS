//
//  PairViewController.swift
//  Smartpad-macOS
//
//  Created by Alireza Azimi on 2022-03-19.
//

import Foundation
import Cocoa
import CoreGraphics

class PairViewController: NSViewController{

    
    @IBOutlet weak var pairingLabel: NSTextField!
    var connectionManager: ConnectionManager!
    var deviceList: [String] = []
    var selectedDevice = ""
    var connData: ConnectionData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connectionManager = ConnectionManager()
        connData = ConnectionData()
        connectionManager.pairVC = self

        /* Now that we are in the main view controller, the settings button should be enabled */
        if #available(macOS 12.0, *) {
            (NSApp.delegate as! AppDelegate).setSettingsEnabled(isEnabled: true)
        }
    }
    func setPairLabel(label: String){
        pairingLabel.stringValue = label
    }
    
    func updateConnectionView(status: ConnStatus){
        (self.view as! MainView).status = status
        self.view.setNeedsDisplay(NSRect(x: 0,y: 0,width: 500,height: 500))
    }
    
    @IBAction func pairButtonSelected(_ sender: NSButton) {
        /* The "pair" button was pressed */
        connectionManager.startJoining()
    }

    @IBAction func settingsButtonSelected(_ sender: NSButton) {
        /* The "settings" button was pressed */
        showSettingsPage()
    }

    func showSettingsPage() {
        /* This is triggered either by the settings button or through the settings menu option in the Mac menu bar */
        let settingsVc = storyboard?.instantiateController(withIdentifier: "settings") as! SettingViewController

        self.presentAsSheet(settingsVc)
    }
}

