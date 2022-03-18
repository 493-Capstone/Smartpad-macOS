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
        let myView = NSHostingView(rootView: InitialView())
            myView.translatesAutoresizingMaskIntoConstraints = false

            self.view.addSubview(myView)
            myView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
            myView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }


    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

