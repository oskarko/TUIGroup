//
//  CitiServiceMock.swift
//  TUIGroup
//
//  Created by Oscar Rodriguez Garrucho on 24/9/23
//  Linkedin: https://www.linkedin.com/in/oscar-garrucho/
//  Copyright © 2023 Oscar Rodriguez Garrucho. All rights reserved.
//

@testable import TUIGroup
import Foundation

final class CitiServiceMock: CitiesProtocol {
    
    let url: URL?
    
    init(url: URL?) {
        self.url = url
    }
    
    func loadConnections() async -> Connections? {
        return Connections(connections: [
            .init(from: "London",
                  to: "Tokyo",
                  coordinates: .init(from: .init(lat: 51.5285582, long: -0.241681),
                                     to: .init(lat: 35.652832, long: 139.839478)),
                  price: 220),
            .init(from: "Tokyo",
                  to: "London",
                  coordinates: .init(from: .init(lat: 35.652832, long: 139.839478),
                                     to: .init(lat: 51.5285582, long: -0.241681)),
                  price: 200),
            .init(from: "London",
                  to: "Porto",
                  coordinates: .init(from: .init(lat: 51.5285582, long: -0.241681),
                                     to: .init(lat: 41.14961, long: -8.61099)),
                  price: 50),
            .init(from: "Tokyo",
                  to: "Sydney",
                  coordinates: .init(from: .init(lat: 35.652832, long: 139.839478),
                                     to: .init(lat: -33.865143, long: 151.2099)),
                  price: 100),
            .init(from: "Sydney",
                  to: "Cape Town",
                  coordinates: .init(from: .init(lat: -33.865143, long: 151.2099),
                                     to: .init(lat: -33.918861, long: 18.4233)),
                  price: 200),
            .init(from: "Cape Town",
                  to: "London",
                  coordinates: .init(from: .init(lat: -33.918861, long: 18.4233),
                                     to: .init(lat: 51.5285582, long: -0.241681)),
                  price: 800),
            .init(from: "London",
                  to: "New York",
                  coordinates: .init(from: .init(lat: 51.5285582, long: -0.241681),
                                     to: .init(lat: 40.73061, long: -73.935242)),
                  price: 400),
            .init(from: "New York",
                  to: "Los Angeles",
                  coordinates: .init(from: .init(lat: 40.73061, long: -73.935242),
                                     to: .init(lat: 34.052235, long: -118.243683)),
                  price: 120),
            .init(from: "Los Angeles",
                  to: "Tokyo",
                  coordinates: .init(from: .init(lat: 34.052235, long: -118.243683),
                                     to: .init(lat: 35.652832, long: 139.839478)),
                  price: 150)
        ])
    }
}
