//
//  Smartpad_macOSUITests.swift
//  Smartpad-macOSUITests
//
//  Created by Alireza Azimi on 2022-03-08.
//

import XCTest
@testable import Smartpad_macOS

class Smartpad_macOSUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
    }
    
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
    
    func testUINavigation() throws {
        resetDefaults()
        app.launch()
        if (!app.buttons["Pair"].exists) {
            if (app.buttons["settings"].exists) {
                app.buttons["settings"].tap()
                app.buttons["unpair"].tap()
                app.buttons["close"].tap()
            } else {
                app.buttons["Submit"].tap()
                app.buttons["_NS:8"].tap()
                app.textFields.element.tap()
                app.textFields.element.typeText("ui test mac\n")
                app.buttons["Submit"].tap()
            }
        }
        XCTAssertTrue(app.buttons["Pair"].exists)
        XCTAssertTrue(app.buttons["settings"].exists)
        app.buttons["Pair"].tap()
        XCTAssertTrue(app.buttons["Cancel"].exists)
        app.buttons["Cancel"].tap()
        app.buttons["settings"].tap()
        XCTAssertTrue(app.buttons["Close"].exists)
        app.textFields.element.typeText(String(UnicodeScalar(8)))
        app.textFields.element.typeText("\n")
        app.buttons["_NS:8"].tap() // tap the ok button
        app.buttons["Close"].tap()
        XCTAssertTrue(app.buttons["Pair"].exists)
    }
}
