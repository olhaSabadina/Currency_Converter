//
//  CurrencyConverterUITests.swift
//  CurrencyConverterUITests
//
//  Created by Olya Sabadina on 2023-04-24.
//

import XCTest
@testable import CurrencyConverter

final class CurrencyConverterUITests: XCTestCase {

    func testPossibilityInputAndDeleteValue() {
        let app = XCUIApplication()
        app.launch()
        let tablesQuery = app.tables
        tablesQuery.cells.containing(.staticText, identifier:"UAH  ").element.tap()
        XCTAssert(tablesQuery.buttons["Clear text"].exists)
        tablesQuery.buttons["Clear text"].tap()
        XCTAssertEqual(tablesQuery.cells.containing(.staticText, identifier:"UAH  ").element.value as! String, "")
        XCTAssert(app.toolbars["Toolbar"].buttons["Done"].exists)
        tablesQuery.cells.containing(.staticText, identifier:"UAH  ").element.typeText("2000")
        XCTAssert(tablesQuery.buttons["Clear text"].exists)
        app.toolbars["Toolbar"].buttons["Done"].tap()
        app/*@START_MENU_TOKEN@*/.buttons["Buy"]/*[[".segmentedControls.buttons[\"Buy\"]",".buttons[\"Buy\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.buttons["Sell"]/*[[".segmentedControls.buttons[\"Sell\"]",".buttons[\"Sell\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    }
    
    func testExistsCurrenciesListTable() {
        let app = XCUIApplication()
        app.launch()
        app/*@START_MENU_TOKEN@*/.staticTexts["Add Currency"]/*[[".buttons[\"Add Currency\"].staticTexts[\"Add Currency\"]",".staticTexts[\"Add Currency\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCTAssert(app.staticTexts["Currencies List"].exists)
        app.tables.children(matching: .cell).element(boundBy: 0).tap()
    }
        
    func testCurrencyTableDeleteCurrency() {
        testExistsCurrenciesListTable()
        let app = XCUIApplication()
        app.launch()
        let tablesQuery = app.tables
        tablesQuery.children(matching: .cell).element(boundBy: 2).tap()
        let window = app.children(matching: .window).element(boundBy: 0)
        let element = window.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element.swipeLeft()
        XCTAssert(tablesQuery/*@START_MENU_TOKEN@*/.buttons["Delete"]/*[[".cells.buttons[\"Delete\"]",".buttons[\"Delete\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists)
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["Delete"]/*[[".cells.buttons[\"Delete\"]",".buttons[\"Delete\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    }
    
    func testCurrencyTableUsingNationalBankExchangeRate() {
        let app = XCUIApplication()
        app.launch()
        XCTAssert(app.staticTexts["National Bank Exchange Rate"].exists)
        app.staticTexts["National Bank Exchange Rate"].tap()
        app.buttons["OK"].tap()
        XCTAssert(app.staticTexts["Return to course PB"].exists)
        app.staticTexts["Return to course PB"].tap()
    }
}
