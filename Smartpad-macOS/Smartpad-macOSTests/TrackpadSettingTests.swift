//
//  TrackpadSettingTests.swift
//  Smartpad-macOSTests
//
//  Created by Arthur Chan on 2022-03-31.
//

import XCTest
@testable import Smartpad_macOS

class TrackpadSettingTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
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
