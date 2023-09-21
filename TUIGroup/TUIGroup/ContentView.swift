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
    
    /// Autocompletion for the input text
    @ObservedObject private var autocomplete = AutocompleteObject()
    
    @State var departureCityInput: String = ""
    @State var destinationCityInput: String = ""
    
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
                TextField("", text: $departureCityInput)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                    .onChange(of: departureCityInput) { newValue in
                        autocomplete.autocomplete(departureCityInput)
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
                TextField("", text: $destinationCityInput)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                    .onChange(of: destinationCityInput) { newValue in
                        autocomplete.autocomplete(destinationCityInput)
                    }
                
            }
            
            HStack {
                Text("Total price: ")
                Text("120")
                    .bold()
                Spacer()
            }
            .padding()
            
            List(autocomplete.suggestions, id: \.self) { suggestion in
                ZStack {
                    Text(suggestion)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .onTapGesture {
                    departureCityInput = suggestion
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
