//
//  ConnectionData.swift
//  Smartpad-macOS
//
//  Created by Alireza Azimi on 2022-03-12.
//

import Foundation

enum StorageError: Error {
    case ValueNotFoundError
}
struct ConnectionKeys {
    static let connDeviceUUID = ""
    static let currDeviceName = ""
}

class ConnectionData {
    let defaults = UserDefaults.standard
    
    func setSelectedDeviceUUID(uuid: String){
        defaults.set(uuid, forKey: ConnectionKeys.connDeviceUUID)
    }
    
    func getSelectedDeviceUUID() throws -> String {
        if let deviceUUID = defaults.string(forKey: ConnectionKeys.connDeviceUUID) {
           return deviceUUID
        } else {
            throw StorageError.ValueNotFoundError
        }
        
    }
    
    func getDeviceName() throws-> String{
        if let deviceName = defaults.string(forKey: ConnectionKeys.currDeviceName) {
           return deviceName
        } else {
            throw StorageError.ValueNotFoundError
        }
    }
    
    func setDeviceName(name: String){
        defaults.set(name, forKey: ConnectionKeys.currDeviceName)
    }
}
