//
//  TrackpadSettingTests.swift
//  Smartpad-macOSTests
//
//  Created by Arthur Chan on 2022-03-31.
//

import XCTest
@testable import Smartpad_macOS

class TrackpadSettingTests: XCTestCase {
    func testEnableReverseScrolling() throws {
        TrackpadSetting.disableReverseScrolling()
        let result = TrackpadSetting.isReverseScrollingEnabled()
        XCTAssertEqual(result, false)
    }

    func testDisableReverseScrolling() throws {
        TrackpadSetting.enableReverseScrolling()
        let result = TrackpadSetting.isReverseScrollingEnabled()
        XCTAssertEqual(result, true)
    }
    
    func testTrackingSpeed() throws {
        TrackpadSetting.setTrackingSpeed(speed: 70)
        let result = TrackpadSetting.getTrackingSpeed()
        XCTAssertEqual(result, 2.4)
    }
}
