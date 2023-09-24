//
//  AnnotatedItem.swift
//  TUIGroup
//
//  Created by Oscar Rodriguez Garrucho on 24/9/23
//  Linkedin: https://www.linkedin.com/in/oscar-garrucho/
//  Copyright © 2023 Oscar Rodriguez Garrucho. All rights reserved.
//

import CoreLocation
import Foundation

// Maps annotations
struct AnnotatedItem: Identifiable {
    let id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D
}

struct MapCoordinate {
    let coordinates: CLLocationCoordinate2D
    let cityName: String
}
