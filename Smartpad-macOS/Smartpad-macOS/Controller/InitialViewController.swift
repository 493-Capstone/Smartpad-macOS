//
//  InitialViewController.swift
//  desktop-client-mac
//
//  Created by alireza azimi on 2022-01-14.
//

import Cocoa
import MultipeerConnectivity
import CoreGraphics



class InitialViewController: NSViewController, NSTextFieldDelegate{
   
    @IBOutlet weak var deviceName: NSTextField!
    var connData: ConnectionData!
    var peerID: MCPeerID!
    var p2pSession: MCSession?
    var mcAdvertiserAssistant: MCAdvertiserAssistant?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        connData = ConnectionData()
        connData.setDeviceName(name: "")
        // set the device uuid upon initial setup
        if (connData.getCurrentDeviceUUID() == ""){
            connData.setCurrentDeviceUUID(uuid: UUID().uuidString)
        }
        deviceName.delegate = self
    }
    
    /**
      Method restricts the available textfield characters
     */
    func controlTextDidChange(_ obj: Notification) {
        let allowedCharacters = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: " '")).inverted // append white space and
        self.deviceName.stringValue =  (self.deviceName.stringValue.components(separatedBy: allowedCharacters as CharacterSet) as NSArray).componentsJoined(by: "")
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
            NameEmptyAlert().runModal()
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}

