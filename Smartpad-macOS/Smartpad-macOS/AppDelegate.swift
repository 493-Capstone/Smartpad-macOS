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

    private var statusItem: NSStatusItem!
    private var settingsButton = NSMenuItem(title: "Settings", action: #selector(openSettings), keyEquivalent: "2")
    @State private var connStatus: ConnStatus = ConnStatus.Unpaired

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            /* Note: This is only supported on MacOS 12, but CI uses MacOS 11 */
            let config = NSImage.SymbolConfiguration(hierarchicalColor: .systemRed)
            button.image = NSImage(systemSymbolName: "circle.fill", accessibilityDescription: "connStatus: unpaired")
            button.image = button.image?.withSymbolConfiguration(config)
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
        menu.autoenablesItems = false

        let status = NSMenuItem(title: "Status: unpaired", action: nil, keyEquivalent: "1")
        /* Clicking the status should never be enabled */
        status.isEnabled = false
        menu.addItem(status)

        menu.addItem(settingsButton)

        menu.addItem(NSMenuItem.separator())

        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))

        statusItem.menu = menu
    }

    @objc func openSettings() {
        /* Show settings page */
        let mainWindow = NSApplication.shared.orderedWindows.first!

        (mainWindow.contentViewController as? PairViewController)?.showSettingsPage()
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
}
