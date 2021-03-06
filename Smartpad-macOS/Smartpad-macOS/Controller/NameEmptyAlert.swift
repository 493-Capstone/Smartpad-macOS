//
//  NameEmptyAlert.swift
//  Smartpad-macOS
//
//  Created by Hudson Shykowski on 2022-03-31.
//

/**
 * Alert shown when an empty name is submitted.
 *
 * Required for FR1 (pairing identifier) to prevent empty device names.
 */

import Foundation
import AppKit

/**
 * Alert shown when an empty name is entered to a text field
 */
class NameEmptyAlert: NSAlert {
    override init() {
        super.init()

        messageText = "Name cannot be empty"

        addButton(withTitle: "OK")
        alertStyle = .warning
    }
}
