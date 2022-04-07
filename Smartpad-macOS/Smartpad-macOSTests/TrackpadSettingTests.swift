//
//  TrackpadSettingTests.swift
//  Smartpad-macOSTests
//
//  Created by Arthur Chan on 2022-03-31.
//

import XCTest
@testable import Smartpad_macOS

class TrackpadSettingTests: XCTestCase {

    override func tearDown() {
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

    /**
     * Tests getting the default reverse scrolling value
     */
    func testDefaultReverseScrolling() throws {
        // Ensure the scrolling value is reset to the default
        resetDefaults()

        let result = TrackpadSetting.isReverseScrollingEnabled()
        XCTAssertEqual(result, false)
    }

    /**
     * Tests enabling reverse scrolling
     */
    func testEnableReverseScrolling() throws {
        TrackpadSetting.disableReverseScrolling()
        let result = TrackpadSetting.isReverseScrollingEnabled()
        XCTAssertEqual(result, false)
    }

    /**
     * Tests disabling reverse scrolling
     */
    func testDisableReverseScrolling() throws {
        TrackpadSetting.enableReverseScrolling()
        let result = TrackpadSetting.isReverseScrollingEnabled()
        XCTAssertEqual(result, true)
    }

    /**
     * Tests getting the default tracking speed
     */
    func testDefaultTrackingSpeed() throws {
        // Ensure the tracking speed is reset to the default
        resetDefaults()

        let result = TrackpadSetting.getTrackingSpeed()
        XCTAssertEqual(result, 2.0)
    }

    /**
     * Tests setting then getting the tracking speed
     */
    func testTrackingSpeed() throws {
        TrackpadSetting.setTrackingSpeed(speed: 70)
        let result = TrackpadSetting.getTrackingSpeed()
        XCTAssertEqual(result, 2.4)
    }
}
