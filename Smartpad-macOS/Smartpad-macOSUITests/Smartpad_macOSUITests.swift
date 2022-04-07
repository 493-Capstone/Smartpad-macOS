//
//  Smartpad_macOSUITests.swift
//  Smartpad-macOSUITests
//
//  Created by Alireza Azimi on 2022-03-08.
//

import XCTest

class Smartpad_macOSUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
    }

    func testUINavigation() throws {
        app.launch()
        if (!app.buttons["Pair"].exists) {
            app.textFields.element.tap()
            app.textFields.element.typeText("ui test mac\n")
            app.buttons["Submit"].tap()
        }
        XCTAssertTrue(app.buttons["Pair"].exists)
        XCTAssertTrue(app.buttons["settings"].exists)
        app.buttons["Pair"].tap()
        XCTAssertTrue(app.buttons["Cancel"].exists)
        app.buttons["Cancel"].tap()
        app.buttons["settings"].tap()
        XCTAssertTrue(app.buttons["Close"].exists)
        app.buttons["Close"].tap()
        XCTAssertTrue(app.buttons["Pair"].exists)
    }
}
