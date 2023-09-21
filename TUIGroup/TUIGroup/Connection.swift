//
//  Connection.swift
//  TUIGroup
//
//  Created by Oscar Rodriguez Garrucho on 21/9/23
//  Linkedin: https://www.linkedin.com/in/oscar-garrucho/
//  Copyright © 2023 Oscar Rodriguez Garrucho. All rights reserved.
//

import Foundation

struct Connections: Codable {
    let connections: [Connection]
}

struct Connection: Codable {
    let from: String
    let to: String
    let coordinates: BothCoordinates
    let price: Int
}

struct BothCoordinates: Codable {
    let from: Coordinates
    let to: Coordinates
}

struct Coordinates: Codable {
    let lat: Double
    let long: Double
}
