//
//  ConnectionDataTest.swift
//  Smartpad-macOSTests
//
//  Created by Alireza Azimi on 2022-03-12.
//

import XCTest
@testable import Smartpad_macOS

class ConnectionDataTest: XCTestCase {
    override func tearDown(){
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        resetDefaults()
    }
    
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }

    func testSetCurrentDeviceName(){
        // Arrange
        let data = ConnectionData()
        // Act
        let name = "my mac"
        data.setDeviceName(name: name)
        //Assert
        XCTAssertEqual(UserDefaults.standard.string(forKey: ConnectionKeys.currDeviceName), name)
    }
    
    func testGetCurrentDeviceName(){
        //Arrange
        resetDefaults()
        let data = ConnectionData()
        // Act
        let name = "my mac"
        data.setDeviceName(name: name)
        //Assert
        XCTAssertEqual(data.getDeviceName(), name)
    }
    
    func testSetCurrentDeviceUUID(){
        // Arrange
        resetDefaults()
        let uuidString = UUID().uuidString
        let data = ConnectionData()
        // Act
        data.setCurrentDeviceUUID(uuid: uuidString)
        // Assert
        XCTAssertEqual(UserDefaults.standard.string(forKey: ConnectionKeys.currDeviceUUID), uuidString)
    }
    
    func testGetCurrentDeviceUUID(){
        // Arrange
        resetDefaults()
        let uuidString = UUID().uuidString
        let data = ConnectionData()
        // Act
        data.setCurrentDeviceUUID(uuid: uuidString)
        // Assert
        XCTAssertEqual(data.getCurrentDeviceUUID(), uuidString)
    }
    
    func testSetPeerName(){
        // Arrange
        resetDefaults()
        let data = ConnectionData()
        let peerName = "Ali's phone"
        // Act
        data.setSelectedPeer(name: peerName)
        // Assert
        XCTAssertEqual(UserDefaults.standard.string(forKey: ConnectionKeys.selectedPeerName), peerName)
    }
    
    func testGetPeerName(){
        // Arrange
        resetDefaults()
        let data = ConnectionData()
        let peerName = "Ali's phone"
        // Act
        data.setSelectedPeer(name: peerName)
        // Assert
        XCTAssertEqual(data.getSelectedPeer(), peerName)
    }
}
