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
    var deviceList: [String] = []
    var selectedDevice = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ConnectionManagerAccess.connectionManager.pairVC = self
    }
    
    func setPairLabel(label: String){
        pairingLabel.stringValue = label
    }
    
    func updateConnectionView(status: ConnStatus){
        (self.view as! MainView).status = status
        self.view.setNeedsDisplay(NSRect(x: 0,y: 0,width: 500,height: 500))
    }
    

}

