//
//  GestureTests.swift
//  Smartpad-macOSTests
//
//  Created by Arthur Chan on 2022-04-01.
//

import XCTest
@testable import Smartpad_macOS

class GestureTests: XCTestCase {

    func testZoomGesture() throws {
        var result = ZoomGesture.handlesGesture(gestureType: GestureType.PinchStarted)
        XCTAssertEqual(result, true)
        result = ZoomGesture.handlesGesture(gestureType: GestureType.PinchChanged)
        XCTAssertEqual(result, true)
        result = ZoomGesture.handlesGesture(gestureType: GestureType.PinchEnded)
        XCTAssertEqual(result, true)
    }

    func testSingleTapGesture() throws {
        let result = SingleTapGesture.handlesGesture(gestureType: GestureType.SingleTap)
        XCTAssertEqual(result, true)
    }
    
    func testSingleTapDoubleClickGesture() throws {
        let result = SingleTapDoubleClickGesture.handlesGesture(gestureType: GestureType.SingleTapDoubleClick)
        XCTAssertEqual(result, true)
    }
    
    func testDoubleTapGesture() throws {
        let result = DoubleTapGesture.handlesGesture(gestureType: GestureType.DoubleTap)
        XCTAssertEqual(result, true)
    }
    
    func testSinglePanGesture() throws {
        var result = SinglePanGesture.handlesGesture(gestureType: GestureType.SinglePanStarted)
        XCTAssertEqual(result, true)
        result = SinglePanGesture.handlesGesture(gestureType: GestureType.SinglePanChanged)
        XCTAssertEqual(result, true)
        result = SinglePanGesture.handlesGesture(gestureType: GestureType.SinglePanEnded)
        XCTAssertEqual(result, true)
    }
    
    func testDoublePanGesture() throws {
        var result = DoublePanGesture.handlesGesture(gestureType: GestureType.DoublePanStarted)
        XCTAssertEqual(result, true)
        result = DoublePanGesture.handlesGesture(gestureType: GestureType.DoublePanChanged)
        XCTAssertEqual(result, true)
        result = DoublePanGesture.handlesGesture(gestureType: GestureType.DoublePanEnded)
        XCTAssertEqual(result, true)
    }
    
    func testDragPanGesture() throws {
        var result = DragPanGesture.handlesGesture(gestureType: GestureType.DragPanStarted)
        XCTAssertEqual(result, true)
        result = DragPanGesture.handlesGesture(gestureType: GestureType.DragPanChanged)
        XCTAssertEqual(result, true)
        result = DragPanGesture.handlesGesture(gestureType: GestureType.DragPanEnded)
        XCTAssertEqual(result, true)
    }
}
