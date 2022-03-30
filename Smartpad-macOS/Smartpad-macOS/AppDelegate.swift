//
//  AppDelegate.swift
//  Smartpad-macOS
//
//  Created by Alireza Azimi on 2022-03-08.
//

import Cocoa
import SwiftUI

@available(macOS 12.0, *)
@main
class AppDelegate: NSObject, NSApplicationDelegate {

    /* The status image (red, yellow, green circle) */
    private var statusItem: NSStatusItem?

    /* The status menu text (i.e. Status: Unpaired) */
    private var statusText = NSMenuItem(title: "Status: Unpaired", action: nil, keyEquivalent: "1")
    private var settingsButton = NSMenuItem(title: "Settings", action: #selector(openSettings), keyEquivalent: "2")
    @State private var connStatus: ConnStatus = ConnStatus.Unpaired

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        /* Set the status to initially unpaired: We will update whenever a message is recevied from MainView */
        updateConnMenuStatus(status: .Unpaired)

        initConnMenuStatus()
        
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
        menu.autoenablesItems = false

        /* Clicking the status should never be enabled */
        statusText.isEnabled = false

        menu.addItem(statusText)
        menu.addItem(settingsButton)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))

        statusItem?.menu = menu
    }

    @objc func openSettings() {
        /* Show settings page */
        let mainWindow = NSApplication.shared.orderedWindows.first!

        (mainWindow.contentViewController as? MainViewController)?.showSettingsPage()
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        for window in NSApplication.shared.windows {
            window.makeKeyAndOrderFront(self)
        }
        return true
    }

    /* Enabled/disables the settings menu item */
    func setSettingsEnabled(isEnabled: Bool) {
        settingsButton.isEnabled = isEnabled
    }

    /* Initial the connection status circle */
    func initConnMenuStatus() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem?.button {
            let config = NSImage.SymbolConfiguration(hierarchicalColor: .systemRed)
            button.image = NSImage(systemSymbolName: "circle.fill", accessibilityDescription: "Status: Unpaired")
            button.image = button.image?.withSymbolConfiguration(config)
        }
    }

    /* Update the menu items related to connection status */
    func updateConnMenuStatus(status: ConnStatus) {
        var newImageConfig: NSImage.SymbolConfiguration
        var newStatus: String

        switch status {
            case .PairedAndConnected:
                newImageConfig = NSImage.SymbolConfiguration(hierarchicalColor: .systemGreen)
                newStatus = "Status: Paired and Connected"

            case .PairedAndDisconnected:
                newImageConfig = NSImage.SymbolConfiguration(hierarchicalColor: .systemYellow)
                newStatus = "Status: Paired and Disconnected"

            case .Unpaired:
                newImageConfig = NSImage.SymbolConfiguration(hierarchicalColor: .systemRed)
                newStatus = "Status: Paired and Disconnected"
        }

        if let button = statusItem?.button {
            button.image = button.image?.withSymbolConfiguration(newImageConfig)
            button.image?.accessibilityDescription = newStatus
            statusText.title = newStatus
        }
    }
}
