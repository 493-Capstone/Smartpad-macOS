//
//  DeviceListViewController.swift
//  Smartpad-macOS
//
//  Created by Alireza Azimi on 2022-03-29.
//

import Foundation
import Cocoa
import CoreGraphics
/**
 * DeviceListViewController Controls the list of peers to connect view.
 * Handles the invitation and connection process.
 *
 * Required for functional requirements FR2 (pairing device)
 * Required for user interface requirement UIR-3 (Device pairing).
 */

class DeviceListViewController: NSViewController {
    var connectionManager: ConnectionManager?
    // index of selected item from list
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
    
    /**
     *  set's index of selected list item
     */
    @objc private func onItemClicked() {
        selectedIndex = tableView.clickedRow
    }
    
    /**
     * refreshes table data
     */
    func updateTable(){
        tableView.reloadData()
        
    }
    
    /**
     * @brief Action handles window dismiss event
     */
    @IBAction func dismissWindow(_ sender: NSButton) {
        connectionManager?.stopSearch()
    }
    
    /**
     * @brief handles whend send invite button is pressed
     */
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
    
  /**
   * @brief Delegate returns number of rows in a table
   */
  func numberOfRows(in tableView: NSTableView) -> Int {
      return (connectionManager?.peerList.count)!
  }

  /**
   * @brief Delegate generates list cells
   */
  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
     
      guard let cell = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? NSTableCellView else { return nil }
      if row <= (connectionManager?.peerList.count)! - 1 {
          
          let device = connectionManager?.peerList[row]
          if (tableColumn?.identifier)!.rawValue == "deviceName" {
              cell.textField?.stringValue = device!.displayName.components(separatedBy: "|")[0]
          }
          
          return cell
          
      } else {
          return nil
      }
  }
}
