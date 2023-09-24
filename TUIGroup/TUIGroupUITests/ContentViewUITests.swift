//
//  ContentViewUITests.swift
//  TUIGroup
//
//  Created by Oscar Rodriguez Garrucho on 24/9/23
//  Linkedin: https://www.linkedin.com/in/oscar-garrucho/
//  Copyright © 2023 Oscar Rodriguez Garrucho. All rights reserved.
//

import XCTest

class ContentViewUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        app = XCUIApplication()
        app.launch() // Launch your app
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    func testAutocompleteAndCalculateRoute() {
        let departureTextField = app.textFields["Departure city"]
        departureTextField.tap()
        departureTextField.typeText("New")
        
        // Tap on the suggestion for "New York"
        app.textFields["New York"].tap()

        let destinationTextField = app.textFields["Destination city"]
        destinationTextField.tap()
        destinationTextField.typeText("Los")
        
        // Tap on the suggestion for "Los Angeles"
        app.textFields["Los Angeles"].tap()
        
        // Validate that the total price label is updated
        let totalPriceLabel = app.staticTexts["Price"]
        XCTAssertTrue(totalPriceLabel.exists)
        XCTAssertEqual(totalPriceLabel.label, "120")
    }
    
}
