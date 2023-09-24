//
//  ContentViewModel.swift
//  TUIGroup
//
//  Created by Oscar Rodriguez Garrucho on 21/9/23
//  Linkedin: https://www.linkedin.com/in/oscar-garrucho/
//  Copyright © 2023 Oscar Rodriguez Garrucho. All rights reserved.
//

import Contacts
import Foundation
import MapKit

@MainActor
final class ContentViewModel: ObservableObject {
    
    @Published var departureCityInput: String = ""
    @Published var destinationCityInput: String = ""
    @Published var cheapestPrice: String = ""
    @Published var suggestions: [Suggestion] = []
    @Published var tripConnections: [Connection] = [] {
        didSet {
            isMapAvailable = !tripConnections.isEmpty
        }
    }
    // MapView reactive properties
    @Published var isMapAvailable: Bool = false
    @Published var placemarks: [MKPlacemark] = []
    @Published var polyline: MKPolyline = .init(coordinates: [], count: 0)
    @Published var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: .zero,
                                                                                                  longitude: .zero),
                                                                   span: MKCoordinateSpan(latitudeDelta: Constants.maxLatDeltaAllowed,
                                                                                          longitudeDelta: Constants.maxLngDeltaAllowed)) // Max zoom allowed
    
    private let source: CitiesProtocol
    private var connections: [Connection]?
    private var flightType: FlightType = .departure
    private var task: Task<Void, Never>?
    
    init(_ source: CitiesProtocol = CitiesService(url: URL(string: Constants.defaultURL))) {
        self.source = source
        Task {
            await loadConnections()
        }
    }
    
    private func loadConnections() async {
        connections = await source.loadConnections()?.connections
    }
    
    func sendAction(_ action: Action, cityName: String? = nil, flightType: FlightType? = .departure) {
        switch action {
        case .autocomplete:
            autocomplete(cityName, flightType: flightType)
        case .calcCheapestRoute:
            calculateCheapestRoute()
        case .selectCity:
            selectCityName(cityName)
        }
    }
    
}

private extension ContentViewModel {
    
    func autocomplete(_ text: String?, flightType: FlightType?) {
        guard
            let flightType = flightType,
            let text = text, !text.isEmpty
        else {
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
            suggestions = newSuggestions.compactMap{ Suggestion(cityName: $0, flightType: self.flightType) }
        }
    }
    
    func calculateCheapestRoute() {
        guard
            !(connections?.filter({ $0.from == departureCityInput }).isEmpty ?? true) &&
                !(connections?.filter({ $0.to == destinationCityInput }).isEmpty ?? true)
        else {
            // handle error message
            if departureCityInput.isEmpty || destinationCityInput.isEmpty {
                cheapestPrice = ""
            }
            else if departureCityInput != destinationCityInput {
                cheapestPrice = "Check your selected cities, please."
            } else {
                cheapestPrice = "Really? 🥲"
            }
            tripConnections = []
            return
        }

        print("========== Cheapest Route ==========")
        
        calculateConnections(from: departureCityInput,
                             blackList: [departureCityInput],
                             selectedConnections: [])

    }
    
    func calculateConnections(from: String, blackList: [String], selectedConnections: [Connection]) {
        guard blackList.count < 9 else {
            return
        }
        
        if let directConnections = connections?
            .filter({ $0.from == from && $0.to == destinationCityInput }),
            !directConnections.isEmpty {
            
            if let cheapestConnection = directConnections.sorted(by: { $0.price > $1.price }).first {
                
                var selectedConnectionsCopy = selectedConnections
                selectedConnectionsCopy.append(cheapestConnection)
                selectedConnectionsCopy.forEach{ $0.printObject() }
                
                // Update MapView
                region.center = .init(latitude: selectedConnectionsCopy.first?.coordinates.from.lat ?? 0.0,
                                      longitude: selectedConnectionsCopy.first?.coordinates.from.long ?? 0.0)
                let coordinates = getMapCoordinate(from: selectedConnectionsCopy)
                polyline = MKPolyline(coordinates: coordinates.map{ $0.coordinates },
                                  count: coordinates.map{ $0.coordinates }.count)
                placemarks = coordinates.compactMap { MKPlacemark(coordinate: $0.coordinates,
                                                            addressDictionary: [CNPostalAddressCountryKey: $0.cityName]) }
                // Update ContentView
                cheapestPrice = String(selectedConnectionsCopy.compactMap({ $0.price }).reduce(0,+))
                tripConnections = selectedConnectionsCopy
            }
        }
        else { // Flight with stops
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
    
    func lookupCities(prefix: String) -> [String] {
        guard let connections = connections else {
            return []
        }
        
        let departureCities = connections.compactMap { self.flightType == .departure ? $0.from : $0.to }
        let uniqueCities = NSOrderedSet(array: departureCities).array as? [String] ?? [] // Avoid duplicated ones
        
        return uniqueCities.filter { $0.hasCaseAndDiacriticInsensitivePrefix(prefix) }
    }
    
    func getMapCoordinate(from connections: [Connection]) -> [MapCoordinate] {
        var coordinates = connections.compactMap{
            MapCoordinate(coordinates: .init(latitude: $0.coordinates.from.lat,
                                             longitude: $0.coordinates.from.long),
                          cityName: $0.from)
        }

        coordinates.append( // destination city
            MapCoordinate(coordinates:
                    .init(latitude: connections.last?.coordinates.to.lat ?? .zero,
                          longitude: connections.last?.coordinates.to.long ?? .zero),
                                               cityName: connections.last?.to ?? "")
        )
        
        return coordinates
    }
}
