//
//  TUITexflied.swift
//  TUIGroup
//
//  Created by Oscar Rodriguez Garrucho on 24/9/23
//  Linkedin: https://www.linkedin.com/in/oscar-garrucho/
//  Copyright © 2023 Oscar Rodriguez Garrucho. All rights reserved.
//

import SwiftUI

struct TUITexflied: View {
    
    private var flightType: FlightType
    @Binding private var input: String
    @Binding private var suggestions: [Suggestion]
    private let onChange: (String, FlightType) -> Void
    private let onSelect: (String, FlightType) -> Void
    @State private var isEditing: Bool = false
    @FocusState private var isFocused: Bool
    
    init(
        input: Binding<String>,
        suggestions: Binding<[Suggestion]>,
        flightType: FlightType,
        onChange: @escaping (String, FlightType) -> Void,
        onSelect: @escaping (String, FlightType) -> Void
    ) {
        self._input = input
        self._suggestions = suggestions
        self.flightType = flightType
        self.onChange = onChange
        self.onSelect = onSelect
    }
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: flightType.imageString)
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text(flightType.titleString)
                Spacer()
            }
            .padding()
            TextField("", text: $input, onEditingChanged: { editingChanged in
                self.isEditing = editingChanged
            })
            .textFieldStyle(.roundedBorder)
            .padding(.horizontal)
            .focused($isFocused)
            .onSubmit { // <--- only on pressing the return key
                onSelect(input, flightType)
            }
            .onChange(of: input) { newValue in
                onChange(newValue, flightType)
            }
            .accessibilityIdentifier(flightType.titleString)
            
            if isEditing {
                VStack {
                    ForEach(suggestions.filter({ $0.flightType == flightType }),
                            id: \.self) { suggestion in
                        HStack {
                            TextField("", text: .constant(suggestion.cityName))
                                .foregroundColor(.white)
                                .disabled(true)
                                .padding(4)
                                .accessibilityIdentifier(suggestion.cityName)
                            Spacer()
                            
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            input = suggestion.cityName
                            isFocused = false
                            onSelect(suggestion.cityName, flightType)
                        }
                    }
                }
                .background(.gray)
                .cornerRadius(6)
                .padding(.horizontal, 24)
            }
        }
        .animation(.linear(duration: 0.3), value: isEditing)
    }
}

struct TUITexflied_Previews: PreviewProvider {
    @State static var input = ""
    @State static var suggestions: [Suggestion] = []
    
    static var previews: some View {
        TUITexflied(input: $input,
                    suggestions: $suggestions,
                    flightType: .departure,
                    onChange:  { _, _ in },
                    onSelect:  { _, _ in })
    }
}
