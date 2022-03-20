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
    var connData: ConnectionData!
    var connectionManager: ConnectionManager?
    override func viewDidLoad() {
        super.viewDidLoad()
        connData = ConnectionData()
        pairingLabel.stringValue = "Pairing with "
        + connData.getSelectedDeviceUUID()
        connectionManager = ConnectionManager()
        connectionManager?.requestPairingForDevice(peerName: connData.getSelectedDeviceUUID())
        
    }

    
}

