//
//  ContentViewModelTests.swift
//  TUIGroup
//
//  Created by Oscar Rodriguez Garrucho on 24/9/23
//  Linkedin: https://www.linkedin.com/in/oscar-garrucho/
//  Copyright © 2023 Oscar Rodriguez Garrucho. All rights reserved.
//

import XCTest
import Combine
@testable import TUIGroup

@MainActor 
class ContentViewModelTests: XCTestCase {
    
    var viewModel: ContentViewModel!
    var mockCitiesServices: CitiServiceMock!
    
    
    override func setUp() {
        super.setUp()
        mockCitiesServices = CitiServiceMock(url: nil)
        viewModel = ContentViewModel(mockCitiesServices)
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testAutocomplete() {
        let asyncWaitDuration = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + asyncWaitDuration) { [weak self] in
            guard let self = self else { return }

            viewModel.sendAction(.autocomplete, cityName: "L", flightType: .departure)
            
            XCTAssertFalse(self.viewModel.suggestions.isEmpty)
            XCTAssertEqual(self.viewModel.suggestions.first?.cityName ?? "", "London")
            XCTAssertEqual(self.viewModel.suggestions.last?.cityName ?? "", "Los Angeles")
        }
    }
    
    func testCalculateCheapestRoute() {
        let asyncWaitDuration = 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + asyncWaitDuration) { [weak self] in
            guard let self = self else { return }

            viewModel.departureCityInput = "Sydney"
            viewModel.destinationCityInput = "Tokyo"
            
            // Calculate cheapest route
            viewModel.sendAction(.calcCheapestRoute)
            XCTAssertFalse(self.viewModel.cheapestPrice.isEmpty)
            XCTAssertEqual(self.viewModel.cheapestPrice, "1220")
            XCTAssertFalse(self.viewModel.tripConnections.isEmpty)
            XCTAssertEqual(self.viewModel.tripConnections.first?.coordinates.to.lat ?? .zero, 35.652832)
        }
    }
    
    func testSelectCityName() {
        viewModel.sendAction(.selectCity, cityName: "New York")
        
        XCTAssertEqual(viewModel.departureCityInput, "New York")
    }
}
