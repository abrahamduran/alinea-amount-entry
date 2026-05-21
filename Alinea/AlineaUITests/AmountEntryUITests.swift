//
//  AmountEntryUITests.swift
//  AlineaUITests
//
//  Created by Abraham Duran on 21/5/26.
//
//  End-to-end happy-path tests. Validate that taps reach the
//  view-model and the display reflects the resulting state.
//

import XCTest

final class AmountEntryUITests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    @MainActor
    func test_tappingDigits_updatesAmount() {
        let app = XCUIApplication()
        app.launch()

        app.buttons["Digit 1"].tap()
        app.buttons["Digit 2"].tap()
        app.buttons["Digit 3"].tap()

        XCTAssertEqual(app.staticTexts["Amount"].value as? String, "$123")
    }

    @MainActor
    func test_quickChip_setsAmount_andSwapsCTA() {
        let app = XCUIApplication()
        app.launch()

        app.buttons["Quick amount $2,000"].tap()

        XCTAssertEqual(app.staticTexts["Amount"].value as? String, "$2,000")

        // Chips → Review morph: chip is gone, Review button is hittable.
        XCTAssertTrue(app.buttons["Review"].waitForExistence(timeout: 1))
        XCTAssertFalse(app.buttons["Quick amount $500"].exists)
    }

    @MainActor
    func test_decimalRule_blocksSecondDot() {
        let app = XCUIApplication()
        app.launch()

        app.buttons["Digit 5"].tap()
        app.buttons["Decimal point"].tap()
        app.buttons["Digit 0"].tap()
        // Second decimal must be a no-op (visually disabled, but tap
        // anyway to prove the rule holds).
        app.buttons["Decimal point"].tap()

        XCTAssertEqual(app.staticTexts["Amount"].value as? String, "$5.0")
    }
}
