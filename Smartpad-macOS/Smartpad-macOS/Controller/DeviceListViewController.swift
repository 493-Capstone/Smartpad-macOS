//
//  DeviceListViewController.swift
//  Smartpad-macOS
//
//  Created by Alireza Azimi on 2022-03-29.
//

import Foundation
import Cocoa
import CoreGraphics

class DeviceListViewController: NSViewController {
    var connectionManager: ConnectionManager?
    var selectedIndex = -1
    
    @IBOutlet weak var tableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connectionManager = ConnectionManagerAccess.connectionManager
        connectionManager?.searchForDevices()
        connectionManager?.listVC = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.action = #selector(onItemClicked)
        
    }
    
    @objc private func onItemClicked() {
        selectedIndex = tableView.clickedRow
    }
    
    func updateTable(){
        tableView.reloadData()
        
    }
    
    
    @IBAction func dismissWindow(_ sender: NSButton) {
        connectionManager?.stopSearch()
    }
    
    @IBAction func sendInvite(_ sender: NSButton) {
        if selectedIndex == -1 {
            let ac = NSAlert()
            ac.messageText = "No device selected"
            ac.alertStyle = .warning
            ac.addButton(withTitle: "OK")
            ac.runModal()
            
        } else{
            connectionManager?.sendInviteToPeer(index: selectedIndex)
            self.dismiss(true)
        }
    }
}

extension DeviceListViewController: NSTableViewDataSource, NSTableViewDelegate {
    
  func numberOfRows(in tableView: NSTableView) -> Int {
      return (connectionManager?.peerList.count)!
  }

  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
     
      guard let cell = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? NSTableCellView else { return nil }
      if row <= (connectionManager?.peerList.count)! - 1 {
          
          let device = connectionManager?.peerList[row]
          if (tableColumn?.identifier)!.rawValue == "deviceName" {
              cell.textField?.stringValue = device!.displayName
          }
          
          return cell
          
      } else {
          return nil
      }
  }
}
