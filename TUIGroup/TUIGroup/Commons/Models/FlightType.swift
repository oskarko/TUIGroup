//
//  FlightType.swift
//  TUIGroup
//
//  Created by Oscar Rodriguez Garrucho on 24/9/23
//  Linkedin: https://www.linkedin.com/in/oscar-garrucho/
//  Copyright © 2023 Oscar Rodriguez Garrucho. All rights reserved.
//

import Foundation

enum FlightType: Codable {
    case departure
    case destination
    
    var imageString: String {
        switch self {
        case .departure: return "airplane.departure"
        case .destination: return "airplane.arrival"
        }
    }
    
    var titleString: String {
        switch self {
        case .departure: return "Departure city"
        case .destination: return "Destination city"
        }
    }
}
