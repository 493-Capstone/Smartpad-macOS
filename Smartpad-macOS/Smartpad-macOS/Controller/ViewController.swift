//
//  ViewController.swift
//  desktop-client-mac
//
//  Created by alireza azimi on 2022-01-14.
//

import Cocoa
import MultipeerConnectivity
import CoreGraphics
import SwiftUI

class ViewController: NSViewController{
    var connectionManager: ConnectionManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        connectionManager = ConnectionManager()
    }


    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

