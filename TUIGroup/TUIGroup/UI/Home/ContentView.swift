//
//  ContentView.swift
//  TUIGroup
//
//  Created by Oscar Rodriguez Garrucho on 21/9/23
//  Linkedin: https://www.linkedin.com/in/oscar-garrucho/
//  Copyright © 2023 Oscar Rodriguez Garrucho. All rights reserved.
//

import MapKit
import SwiftUI

struct ContentView: View {
    
    @ObservedObject private var viewModel = ContentViewModel()
    
    var body: some View {
        VStack {
            TUITexflied(input: $viewModel.departureCityInput,
                        suggestions: $viewModel.suggestions,
                        flightType: .departure,
                        onChange: { newValue, flightType in
                viewModel.sendAction(.autocomplete, cityName: newValue, flightType: flightType)
            },
                        onSelect: { cityName in
                viewModel.sendAction(.selectCity, cityName: cityName)
                viewModel.sendAction(.calcCheapestRoute)
            })
            
            TUITexflied(input: $viewModel.destinationCityInput,
                        suggestions: $viewModel.suggestions,
                        flightType: .destination,
                        onChange: { newValue, flightType in
                viewModel.sendAction(.autocomplete, cityName: newValue, flightType: flightType)
            },
                        onSelect: { cityName in
                viewModel.sendAction(.selectCity, cityName: cityName)
                viewModel.sendAction(.calcCheapestRoute)
            })
            
            HStack {
                Text("Total price: ")
                Text(viewModel.cheapestPrice)
                    .bold()
                    .accessibilityIdentifier("Price")
                Spacer()
            }
            .padding()
            
            if viewModel.isMapAvailable {
                map
                .layoutPriority(1)
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    }
    
    var map: some View {
        MapViewRepresentable(
            viewModel: .init(
                $viewModel.placemarks,
                polyline: $viewModel.polyline,
                region: $viewModel.region
            )
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
