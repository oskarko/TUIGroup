//
//  AutocompleteObject.swift
//  TUIGroup
//
//  Created by Oscar Rodriguez Garrucho on 21/9/23
//  Linkedin: https://www.linkedin.com/in/oscar-garrucho/
//  Copyright © 2023 Oscar Rodriguez Garrucho. All rights reserved.
//

import Foundation

final class AutocompleteObject: ObservableObject {
    
    let delay: TimeInterval = 0.3
    
    @Published var suggestions: [String] = []
    
    init() {
    }
    
    private let citiesCache = CitiesCache(source: CitiesService(location: URL(string: "https://raw.githubusercontent.com/TuiMobilityHub/ios-code-challenge/master/connections.json")!))
    
    private var task: Task<Void, Never>?
    
    func autocomplete(_ text: String) {
        guard !text.isEmpty else {
            suggestions = []
            task?.cancel()
            return
        }
        
        task?.cancel()
        
        task = Task {
            await Task.sleep(UInt64(delay * 1_000_000_000.0))
            
            guard !Task.isCancelled else {
                return
            }
            
            let newSuggestions = citiesCache.lookupDepartureCities(prefix: text)
            
            if isSingleSuggestion(suggestions, equalTo: text) {
                // Do not offer only one suggestion same as the input
                suggestions = []
            } else {
                suggestions = newSuggestions
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
