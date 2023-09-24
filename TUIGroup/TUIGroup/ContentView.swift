//
//  ContentView.swift
//  TUIGroup
//
//  Created by Oscar Rodriguez Garrucho on 21/9/23
//  Linkedin: https://www.linkedin.com/in/oscar-garrucho/
//  Copyright © 2023 Oscar Rodriguez Garrucho. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject private var viewModel = ContentViewModel()
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Image(systemName: "airplane.departure")
                        .imageScale(.large)
                        .foregroundColor(.accentColor)
                    Text("Departure city")
                    Spacer()
                }
                .padding()
                TextField("", text: $viewModel.departureCityInput)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                    .onChange(of: viewModel.departureCityInput) { newValue in
                        viewModel.autocomplete(newValue,
                                               flightType: .departure)
                    }
                
            }
            
            VStack {
                HStack {
                    Image(systemName: "airplane.arrival")
                        .imageScale(.large)
                        .foregroundColor(.accentColor)
                    Text("Destination city")
                    Spacer()
                }
                .padding()
                TextField("", text: $viewModel.destinationCityInput)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                    .onChange(of: viewModel.destinationCityInput) { newValue in
                        viewModel.autocomplete(newValue,
                                               flightType: .destination)
                    }
                
            }
            
            HStack {
                Text("Total price: ")
                Text(viewModel.cheapestPrice)
                    .bold()
                Spacer()
            }
            .padding()
            
            List(viewModel.suggestions, id: \.self) { suggestion in
                ZStack {
                    Text(suggestion.cityName)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .onTapGesture {
                    viewModel.sendAction(.selectCity, cityName: suggestion.cityName)
                    viewModel.sendAction(.calcCheapestRoute)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
