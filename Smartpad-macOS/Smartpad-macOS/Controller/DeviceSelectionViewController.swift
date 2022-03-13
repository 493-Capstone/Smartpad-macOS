//
//  DeviceSelectionViewController.swift
//  Smartpad-macOS
//
//  Created by Alireza Azimi on 2022-03-13.
//

import Foundation
import Cocoa
import MultipeerConnectivity
import CoreGraphics

class DeviceSelectionViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate{
    let mockList: [String] = ["device 1", "device 2", "device 3", "device 4", "device 5"]
    @IBOutlet weak var deviceListView: NSTableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        deviceListView.delegate = self
        deviceListView.dataSource = self
        
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return mockList.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let item = mockList[row]
        
        if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "deviceInfoColumn") {
            let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "deviceInfoColumn")
            guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView else { return nil }
            cellView.textField?.stringValue = item
            return cellView
        }
        
        return nil
 
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


  }
    
    
