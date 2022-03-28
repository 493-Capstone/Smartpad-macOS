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

    }
    func setPairLabel(label: String){
        pairingLabel.stringValue = label
    }
    
    func updateConnectionView(status: ConnStatus){
        (self.view as! MainView).status = status
        self.view.setNeedsDisplay(NSRect(x: 0,y: 0,width: 500,height: 500))
    }
    
    @IBAction func pairButtonSelected(_ sender: NSButton) {
        connectionManager.startJoining()
    }
}

