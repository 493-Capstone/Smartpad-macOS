//
//  DeviceListViewController.swift
//  Smartpad-macOS
//
//  Created by Alireza Azimi on 2022-03-19.
//


import Foundation
import Cocoa
import MultipeerConnectivity
import CoreGraphics

class DeviceSelectionViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate{
    var connectionManager: ConnectionManager?
    var deviceList: [String] = []
    var selectedDevice = ""
    var connData: ConnectionData!
    
    @IBOutlet weak var deviceListView: NSTableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connectionManager = ConnectionManager()
        connData = ConnectionData()
        connectionManager?.listVC = self
        deviceListView.delegate = self
        deviceListView.dataSource = self
        deviceListView.action = #selector(onItemClicked)

    }

    @IBAction func confirmDeviceSelected(_ sender: NSButton) {
        if self.selectedDevice != ""{
            self.connData.setSelectedDeviceUUID(uuid: selectedDevice)
            
            if let controller = self.storyboard?.instantiateController(withIdentifier: "PairView") as? PairViewController {
        self.view.window?.contentViewController = controller
        }
        } else {
            let alert = NSAlert()

            alert.messageText = "No device selected"

            alert.addButton(withTitle: "OK")
            alert.alertStyle = .warning
            alert.runModal()
        }
        
        
    }
    
}

extension DeviceSelectionViewController{
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return deviceList.count
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let item = deviceList[row]

        if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "deviceName") {
            let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "deviceName")
            guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView else { return nil }
            cellView.textField?.stringValue = item
            return cellView
        }

        return nil

    }
    
    @objc private func onItemClicked() {
        print( deviceListView.clickedRow )

        if deviceListView.clickedRow != -1{
            
            selectedDevice = deviceList[deviceListView.clickedRow]

        }
        
    }
    
        
}
