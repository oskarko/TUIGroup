//
//  CitiesService.swift
//  TUIGroup
//
//  Created by Oscar Rodriguez Garrucho on 21/9/23
//  Linkedin: https://www.linkedin.com/in/oscar-garrucho/
//  Copyright © 2023 Oscar Rodriguez Garrucho. All rights reserved.
//

import Foundation

struct CitiesService: CitiesSource {
    
    let location: URL
    
    init(location: URL) {
        self.location = location
    }
    
    func loadDepartureCities() -> [String] {
        do {
            let data = try Data(contentsOf: location)
            let connections = try JSONDecoder().decode(Connections.self, from: data)
            let departureCities = connections.connections.compactMap { $0.from }
            
            return NSOrderedSet(array: departureCities).array as? [String] ?? [] // Avoid duplicated ones
        }
        catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func loadDestinationCities() -> [String] {
        do {
            let data = try Data(contentsOf: location)
            let connections = try JSONDecoder().decode(Connections.self, from: data)
            let destinationCities = connections.connections.compactMap { $0.to }
            
            return NSOrderedSet(array: destinationCities).array as? [String] ?? [] // Avoid duplicated ones
        }
        catch {
            return []
        }
    }
}
