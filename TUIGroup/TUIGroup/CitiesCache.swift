//
//  CitiesCache.swift
//  TUIGroup
//
//  Created by Oscar Rodriguez Garrucho on 21/9/23
//  Linkedin: https://www.linkedin.com/in/oscar-garrucho/
//  Copyright © 2023 Oscar Rodriguez Garrucho. All rights reserved.
//

protocol CitiesSource {
    func loadDepartureCities() async -> [String]
    func loadDestinationCities() async -> [String]
}

/// The `CitiesCache` object manages the list of city names loaded from an external source.
class CitiesCache {
    
    /// Source to load city names.
    let source: CitiesSource
    
    init(source: CitiesSource) {
        self.source = source
    }
    
    /// The list of departure city names.
    func getDepartureCities() async -> [String] {
        if let cities = cachedDepartureCities {
            return cities
        }
        let cities = await source.loadDepartureCities()
        cachedDepartureCities = cities
        
        return cities
    }
    
    /// The list of destination city names.
    func getDestinationCities() async -> [String] {
        if let cities = cachedDestinationCities {
            return cities
        }
        
        let cities = await source.loadDestinationCities()
        cachedDestinationCities = cities
        
        return cities
    }
    
    private var cachedDepartureCities: [String]?
    private var cachedDestinationCities: [String]?
}

extension CitiesCache {
    
    /// Returns a list of city names filtered using given prefix.
    /// Lookup is a linear time operation.
    func lookupDepartureCities(prefix: String) async -> [String] {
        await getDepartureCities().filter { $0.hasCaseAndDiacriticInsensitivePrefix(prefix) }
    }
    
    func lookupDestinationCities(prefix: String) async -> [String] {
        await getDestinationCities().filter { $0.hasCaseAndDiacriticInsensitivePrefix(prefix) }
    }
}
