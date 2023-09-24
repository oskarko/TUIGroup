//
//  ContentViewModel.swift
//  TUIGroup
//
//  Created by Oscar Rodriguez Garrucho on 21/9/23
//  Linkedin: https://www.linkedin.com/in/oscar-garrucho/
//  Copyright © 2023 Oscar Rodriguez Garrucho. All rights reserved.
//

import Combine
import Foundation

enum Action {
    case selectCity
    case calcCheapestRoute
}

enum FlightType: Codable {
    case departure
    case destination
}

@MainActor
final class ContentViewModel: ObservableObject {
    
    @Published var departureCityInput: String = ""
    @Published var destinationCityInput: String = ""
    @Published var cheapestPrice: String = ""
    @Published var suggestions: [Suggestion] = []
    @Published var tripConnections: [Connection] = []
    
    private let source: CitiesProtocol
    private var connections: [Connection]?
    
    private var flightType: FlightType = .departure
    private var task: Task<Void, Never>?
    
    init(_ source: CitiesProtocol = CitiesService(url: URL(string: "https://raw.githubusercontent.com/TuiMobilityHub/ios-code-challenge/master/connections.json")!)) {
        self.source = source
        Task {
            await loadConnections()
        }
    }
    
    private func loadConnections() async {
        connections = await source.loadConnections()?.connections
    }
    
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
            
            let newSuggestions = lookupCities(prefix: text)
            
            if isSingleSuggestion(suggestions.compactMap{ $0.cityName }, equalTo: text) {
                // Do not offer only one suggestion same as the input
                suggestions = []
            } else {
                suggestions = newSuggestions.compactMap{ Suggestion(cityName: $0, flightType: self.flightType) }
            }
        }
    }
    
    func sendAction(_ action: Action, cityName: String? = nil) {
        switch action {
        case .calcCheapestRoute:
            calculateCheapestRoute()
        case .selectCity:
            selectCityName(cityName)
        }
    }
    
}

private extension ContentViewModel {
    
    func calculateCheapestRoute() {
        if !departureCityInput.isEmpty && !destinationCityInput.isEmpty {
            print("========== Cheapest Route ==========")
            
            calculateConnections(from: departureCityInput,
                                 blackList: [departureCityInput],
                                 selectedConnections: [])
        }
    }
    
    func calculateConnections(from: String, blackList: [String], selectedConnections: [Connection]) {
        guard blackList.count < 4 else {
            return
        }
        
        if let directConnections = connections?
            .filter({ $0.from == from && $0.to == destinationCityInput }),
            !directConnections.isEmpty {
            
            if let cheapestConnection = directConnections.sorted(by: { $0.price > $1.price }).first {
                
                var selectedConnectionsCopy = selectedConnections
                selectedConnectionsCopy.append(cheapestConnection)
                selectedConnectionsCopy.forEach{ $0.printObject() }
                
                cheapestPrice = String(selectedConnectionsCopy.compactMap({ $0.price }).reduce(0,+))
                tripConnections = selectedConnectionsCopy
            }
        }
        else { // Indirect flights
            for connection in connections?.filter({ $0.from == from }) ?? [] {
                var blackListCopy = blackList
                var selectedConnectionsCopy = selectedConnections
                
                if  !blackList.contains(connection.to) {
                    
                    selectedConnectionsCopy.append(connection)
                    blackListCopy.append(connection.from)
                    
                    calculateConnections(from: connection.to,
                                         blackList: blackListCopy,
                                         selectedConnections: selectedConnectionsCopy)
                }
            }
        }
    }
    
    func selectCityName(_ cityName: String?) {
        guard let cityName = cityName else {
            return
        }
        switch flightType {
        case .departure: departureCityInput = cityName
        case .destination: destinationCityInput = cityName
        }
    }
    
    /// Returns a list of city names filtered using given prefix.
    /// Lookup is a linear time operation.
    func lookupCities(prefix: String) -> [String] {
        guard let connections = connections else {
            return []
        }
        
        let departureCities = connections.compactMap { self.flightType == .departure ? $0.from : $0.to }
        let uniqueCities = NSOrderedSet(array: departureCities).array as? [String] ?? [] // Avoid duplicated ones
        
        return uniqueCities.filter { $0.hasCaseAndDiacriticInsensitivePrefix(prefix) }
    }
    
    func isSingleSuggestion(_ suggestions: [String], equalTo text: String) -> Bool {
        guard let suggestion = suggestions.first, suggestions.count == 1 else {
            return false
        }
        
        return suggestion.lowercased() == text.lowercased()
    }
}
