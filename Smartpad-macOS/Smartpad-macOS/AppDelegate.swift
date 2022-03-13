//
//  AppDelegate.swift
//  Smartpad-macOS
//
//  Created by Alireza Azimi on 2022-03-08.
//

import Cocoa
import SwiftUI

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    private var statusItem: NSStatusItem!
    @State private var connStatus: ConnStatus = ConnStatus.Unpaired

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
    //          TODO: Only supported on MacOS 12, but CI uses MacOS 11
    //            let config = NSImage.SymbolConfiguration(hierarchicalColor: .systemRed) SMAR-69
                button.image = NSImage(systemSymbolName: "circle.fill", accessibilityDescription: "connStatus: unpaired")
    //            button.image = button.image?.withSymbolConfiguration(config)
        }
        
        setupMenus()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    func setupMenus() {
        let menu = NSMenu()

        let status = NSMenuItem(title: "Status: unpaired", action: #selector(statusSelect), keyEquivalent: "1")
        menu.addItem(status)

        let settings = NSMenuItem(title: "Settings", action: #selector(openSettings), keyEquivalent: "2")
        menu.addItem(settings)

        menu.addItem(NSMenuItem.separator())

        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))

        statusItem.menu = menu
    }

    @objc func statusSelect() {
        
    }

    @objc func openSettings() {
        print("open setting button from the menu bar")
    }

}

