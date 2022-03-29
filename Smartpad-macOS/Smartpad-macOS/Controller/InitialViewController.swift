//
//  InitialViewController.swift
//  desktop-client-mac
//
//  Created by alireza azimi on 2022-01-14.
//

import Cocoa
import MultipeerConnectivity
import CoreGraphics



class InitialViewController: NSViewController{
   
    @IBOutlet weak var deviceName: NSTextField!
    var connData: ConnectionData!
    var peerID: MCPeerID!
    var p2pSession: MCSession?
    var mcAdvertiserAssistant: MCAdvertiserAssistant?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connData = ConnectionData()        
    }
    
    override func viewDidAppear() {
        self.view.window?.title = "Smartpad"

        /* Don't allow resizing the window */
        super.view.window?.styleMask.remove(.resizable)

        /* The settings menu itme should be disabled until the initial setup is complete */
        if #available(macOS 12.0, *) {
            (NSApp.delegate as! AppDelegate).setSettingsEnabled(isEnabled: false)
        }

        /* If an identifier was already set, transition to the main view */
        if (connData.getDeviceName() != "") {
            print("Device name: ", connData.getDeviceName())
            if let controller = self.storyboard?.instantiateController(withIdentifier: "PairView") as? MainViewController {
                self.view.window?.contentViewController = controller
            }
        }
    }
    
    @IBAction func submitDeviceName(_ sender: NSButton) {
        let val = deviceName.stringValue
        print(val)
        if val != ""{
            self.connData.setDeviceName(name: val)
            if let controller = self.storyboard?.instantiateController(withIdentifier: "PairView") as? MainViewController {
        self.view.window?.contentViewController = controller
        }
        } else {
            let alert = NSAlert()

            alert.messageText = "Name cannot be empty"

            alert.addButton(withTitle: "OK")
            alert.alertStyle = .warning
            alert.runModal()
        }
        
    }
    

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}

