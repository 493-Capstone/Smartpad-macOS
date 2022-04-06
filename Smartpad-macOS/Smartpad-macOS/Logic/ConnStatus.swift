//
//  ConnStatus.swift
//  Smartpad-macOS
//
//  Created by Arthur Chan on 2022-03-13.
//

/**
 * Connection status types.
 *
 * Required for connection status functional requirement FR16
 */

public enum ConnStatus {
    case Unpaired
    case PairedAndConnected
    case PairedAndDisconnected
}
