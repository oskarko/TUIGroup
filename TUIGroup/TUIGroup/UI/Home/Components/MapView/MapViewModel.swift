//
//  MapViewModel.swift
//  TUIGroup
//
//  Created by Oscar Rodriguez Garrucho on 24/9/23
//  Linkedin: https://www.linkedin.com/in/oscar-garrucho/
//  Copyright © 2023 Oscar Rodriguez Garrucho. All rights reserved.
//

import Contacts
import Foundation
import MapKit
import SwiftUI

final class MapViewModel: ObservableObject {
    
    @Binding var placemarks: [MKPlacemark]
    @Binding var polyline: MKPolyline
    @Binding var region: MKCoordinateRegion
    
    init(_ placemarks: Binding<[MKPlacemark]>, polyline: Binding<MKPolyline>, region: Binding<MKCoordinateRegion>) {
        self._placemarks = placemarks
        self._polyline = polyline
        self._region = region
    }
    
}
