//
//  AutocompleteObject.swift
//  TUIGroup
//
//  Created by Oscar Rodriguez Garrucho on 21/9/23
//  Linkedin: https://www.linkedin.com/in/oscar-garrucho/
//  Copyright © 2023 Oscar Rodriguez Garrucho. All rights reserved.
//

import Foundation

@MainActor
final class AutocompleteObject: ObservableObject {
    
    @Published var suggestions: [Suggestion] = []
    
    private let citiesCache = CitiesCache(source: CitiesService(url: URL(string: "https://raw.githubusercontent.com/TuiMobilityHub/ios-code-challenge/master/connections.json")!))
    
    private var flightType: FlightType = .departure
    private var task: Task<Void, Never>?
    
    init() {}
    
    func autocomplete(_ text: String, flightType: FlightType) {
        guard !text.isEmpty else {
            suggestions = []
            task?.cancel()
            return
        }
        
        task?.cancel()
        
        self.flightType = flightType
        task = Task {
            guard !Task.isCancelled else {
                return
            }
            
            var newSuggestions: [String] = []
            switch self.flightType {
            case .departure:
                newSuggestions = await citiesCache.lookupDepartureCities(prefix: text)
            case .destination:
                newSuggestions = await citiesCache.lookupDestinationCities(prefix: text)
            }
            
            if isSingleSuggestion(suggestions.compactMap{ $0.cityName }, equalTo: text) {
                // Do not offer only one suggestion same as the input
                suggestions = []
            } else {
                suggestions = newSuggestions.compactMap{ Suggestion(cityName: $0, flightType: self.flightType) }
            }
        }
    }
    
    private func isSingleSuggestion(_ suggestions: [String], equalTo text: String) -> Bool {
        guard let suggestion = suggestions.first, suggestions.count == 1 else {
            return false
        }
        
        return suggestion.lowercased() == text.lowercased()
    }
}
